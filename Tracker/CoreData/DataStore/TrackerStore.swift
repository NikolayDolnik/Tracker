//
//  TrackerStore.swift
//  Tracker
//
//  Created by Dolnik Nikolay on 03.11.2023.
//

import UIKit
import CoreData

final class TrackerStore: NSObject {
    
    private let entityName = "TrackerCoreData"
    private var pinnedCategory = " Закрепленные"
//    private var notPinnedPredicate = NSPredicate(format: "%K == %@",
//                                                    #keyPath(TrackerCoreData.isPinned),
//                                                    false)
//    private var pinnedPredicate = NSPredicate(format: "NONE %K == %@",
//                                              #keyPath(TrackerCoreData.isPinned),
//                                              false)
    
    private let UIcolorMarshalling = UIColorMarshalling()
    private let context: NSManagedObjectContext
    private var insertedIndexes: IndexSet?
    private var deletedIndexes: IndexSet?
    lazy var calendar: Calendar = {
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        return calendar
    }()
    weak var delegate: StoreDelegateProtocol?
    lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {

        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: entityName)
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "category.categoryName", ascending: true)
        ]
        let predicate = NSPredicate(format: "%K == false",
                                    #keyPath(TrackerCoreData.isPinned))
        fetchRequest.predicate = predicate
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: context,
                                                                  sectionNameKeyPath: #keyPath(TrackerCoreData.category.categoryName),
                                                                  cacheName: nil)
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }()
    
    lazy var pinnedFetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {

        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: entityName)
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "category.categoryName", ascending: true),
        ]
        
        let predicate = NSPredicate(format: "%K == true",
                                    #keyPath(TrackerCoreData.isPinned))
        fetchRequest.predicate = predicate
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: context,
                                                                  sectionNameKeyPath: #keyPath(TrackerCoreData.category.categoryName),
                                                                  cacheName: nil)
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }()
    
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    
    // MARK: - Methods Core Data
    
    func addTracker(tracker: Tracker, categoryName: String) throws {
        let trackerCoreData = convertTracker(tracker: tracker)
        let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
        trackerCategoryCoreData.categoryName = categoryName
        trackerCoreData.category = trackerCategoryCoreData
        saveContext()
    }
    
    
    func deleteTracker(for indexPath: IndexPath) throws {
        let deleteTracker = fetchedResultsController.object(at: indexPath)
        context.delete(deleteTracker)
        saveContext()
    }
    
    func convertTracker(tracker: Tracker ) -> TrackerCoreData {
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.name = tracker.name
        trackerCoreData.id = tracker.id
        trackerCoreData.schedule = WeekDay.getShedule(for: tracker.timetable )
        trackerCoreData.colorHex = UIcolorMarshalling.hexString(from: tracker.color)
        trackerCoreData.isPinned = tracker.isPinned
        return trackerCoreData
    }
    
    func fetchTrackers() throws -> [Tracker] {
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        try? fetchedResultsController.performFetch()
        let trackersCD = try? context.fetch(fetchRequest)
        var customTrackers: [Tracker] = []
        try trackersCD?.forEach{ customTrackers.append( try self.getTrackers(from: $0) ) }
        return customTrackers
    }
    
    func getTrackerCoreData(for indexPath: IndexPath) -> TrackerCoreData? {
        return fetchedResultsController.object(at: indexPath)
    }
    
    func getTrackers(from trackerCoreData: TrackerCoreData) throws -> Tracker {
   
        guard let id = trackerCoreData.id,
              let name = trackerCoreData.name,
              let emoji = trackerCoreData.emoji,
              let colorHex = trackerCoreData.colorHex,
              let schedule = trackerCoreData.schedule
        else {
            throw TrackerStoreError.decodingError
        }
        
        return  Tracker(
            id: id,
            name:name,
            color: UIcolorMarshalling.color(from: colorHex),
            emoji: emoji,
            timetable: WeekDay.getTimetable(for: schedule),
            isPinned: trackerCoreData.isPinned
        )
    }
    
    func tracker(for indexPath: IndexPath) -> Tracker? {
        return try? getTrackers(from: fetchedResultsController.object(at: indexPath))
    }
    
    func predicateFetch(numberOfDay: Int){

        let stringDay = WeekDay.getString(for: numberOfDay)
        let predicate = NSPredicate(format: "%K CONTAINS[cd] %@",
                                    #keyPath(TrackerCoreData.schedule),
                                    stringDay)
        let notPinnedPredicate = NSPredicate(format: "%K == %@",
                                                        #keyPath(TrackerCoreData.isPinned),
                                                        false)
        let pinnedPredicate = NSPredicate(format: "NONE %K == %@",
                                                  #keyPath(TrackerCoreData.isPinned),
                                                  false)

//        fetchedResultsController.fetchRequest.predicate = NSCompoundPredicate(type: .and, subpredicates: [predicate, notPinnedPredicate])
//        try? fetchedResultsController.performFetch()
//        let result2 = fetchedResultsController.fetchedObjects
//        result2?.forEach{print("Элементов обычных - \($0.isPinned)")}
//        
        pinnedFetchedResultsController.fetchRequest.predicate = NSCompoundPredicate(type: .and, subpredicates: [predicate, pinnedPredicate]) // , pinnedPredicate
        try? pinnedFetchedResultsController.performFetch()
        
        let result = pinnedFetchedResultsController.fetchedObjects
        result?.forEach{print("Элементов закрепленных - \($0.isPinned)")}
      
    }
    
    func predicateFetch(text: String, numberOfDay: Int){

        let predicate = NSPredicate(format: "%K CONTAINS[cd] %@",
                                    #keyPath(TrackerCoreData.name),
                                    text)
        
        let stringDay = WeekDay.getString(for: numberOfDay)
        let predicateDate = NSPredicate(format: "%K CONTAINS[cd] %@",
                                    #keyPath(TrackerCoreData.schedule),
                                    stringDay)
        
        fetchedResultsController.fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, predicateDate])
        try? fetchedResultsController.performFetch()
    }
    
    func predicateFetch(completedDay: Date){
        
        let dateFrom = calendar.startOfDay(for: completedDay)
        guard let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom) else { return print("Не создался dateTo")}
        print(dateFrom)
        print(dateTo)
        print(completedDay)
        let predicatedayFrom = NSPredicate(format: "ANY record.dateRecord >= %@",
                                            dateFrom as NSDate)
        let predicatedayTo = NSPredicate(format: "ANY record.dateRecord <= %@",
                                            dateTo as NSDate)

        let predicateComplete = NSPredicate(format: "ANY record.dateRecord == %@",
                                            completedDay as CVarArg)
        
        fetchedResultsController.fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicatedayFrom, predicatedayTo])
        try? fetchedResultsController.performFetch()
    }
    
    func predicateFetch(notCompleted: Date){
        
        let dateFrom = calendar.startOfDay(for: notCompleted)
        guard let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom) else { return print("Не создался dateTo")}
        print(dateFrom)
        print(dateTo)
        print(notCompleted)
        let predicatedayFrom = NSPredicate(format: "ANY record.dateRecord >= %@",
                                            dateFrom as NSDate)
        let predicatedayTo = NSPredicate(format: "ANY record.dateRecord <= %@",
                                            dateTo as NSDate)
       
        let predicateNew = NSPredicate(format:  "SUBQUERY(record, $record, $record.dateRecord >= %@ AND $record.dateRecord <= %@).@count == 0", dateFrom as NSDate,
                                            dateTo as NSDate)
        let numberOfDay = Calendar.current.component(.weekday, from: notCompleted as Date ) - 1
        let stringDay = WeekDay.getString(for: numberOfDay)
        let predicateDate = NSPredicate(format: "%K CONTAINS[cd] %@",
                                    #keyPath(TrackerCoreData.schedule),
                                    stringDay)
        
        fetchedResultsController.fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateDate,predicateNew])
        try? fetchedResultsController.performFetch()
    }
    
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if context.hasChanges {
            
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}


// MARK: - NSFetchedResultsControllerDelegate

extension TrackerStore:  NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        // вызывается после сохранения контекста -  стоит сделать обновление коллекции?? + Добавить трекер в категорию
        // Делегать - менеджер который работает с Категориями и трекерам и обновляет таблицу. И рекордом.
        delegate?.didUpdate(StoreUpdate(
                insertedIndexes: insertedIndexes!,
                deletedIndexes: deletedIndexes!
            )
        )
        insertedIndexes = nil
        deletedIndexes = nil
     
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexes = IndexSet()
        deletedIndexes = IndexSet()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .delete:
            if let indexPath = indexPath {
                deletedIndexes?.insert(indexPath.item)
            }
        case .insert:
            if let indexPath = newIndexPath {
                insertedIndexes?.insert(indexPath.item)
            }
        default:
            break
        }
    }
    
}


enum TrackerStoreError: Error {
    case decodingError
}
