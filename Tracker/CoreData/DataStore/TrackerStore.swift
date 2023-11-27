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
    private let UIcolorMarshalling = UIColorMarshalling()
    private let context: NSManagedObjectContext
    private var insertedIndexes: IndexSet?
    private var deletedIndexes: IndexSet?
    weak var delegate: StoreDelegateProtocol?
    lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {

        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: entityName)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "category.categoryName", ascending: false)]
        
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
        //Получаем название категории от VC и ищем их в БД, если нет осоздаем новую категорию. Покаиспользуем кастомную
        let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
        trackerCategoryCoreData.categoryName = categoryName //"Созданно контроллером"
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
            timetable: WeekDay.getTimetable(for: schedule)
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
        fetchedResultsController.fetchRequest.predicate = predicate
        try? fetchedResultsController.performFetch()
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
