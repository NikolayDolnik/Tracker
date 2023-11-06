//
//  TrackerStore.swift
//  Tracker
//
//  Created by Dolnik Nikolay on 03.11.2023.
//

import UIKit
import CoreData

final class TrackerStore: NSObject {
    
    private let modelName = "TrackerDataModel"
    private let UIcolorMarshalling = UIColorMarshalling()
    private let context: NSManagedObjectContext
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {

        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: context,
                                                                  sectionNameKeyPath: nil,
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
        let trackerCategoryCoreData = TrackercategoryCoreData(context: context)
        trackerCategoryCoreData.categoryName = categoryName //"Созданно контроллером"
        trackerCoreData.category = trackerCategoryCoreData
        
        try context.save()
        // saveContext()
    }
    
    func deleteTracker(tracker: Tracker) throws {
        let trackerCoreData = convertTracker(tracker: tracker)
        context.delete(trackerCoreData)
        // try context.save()
        saveContext()
    }
    
    func convertTracker(tracker: Tracker ) -> TrackerCoreData {
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.name = tracker.name
        trackerCoreData.id = tracker.id
        trackerCoreData.schedule = tracker.timetable as NSObject
        trackerCoreData.colorHex = UIcolorMarshalling.hexString(from: tracker.color)
        
        return trackerCoreData
    }
    
    
    func fetchTrackers() throws -> [Tracker] {
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]

        let trackersCD = try? context.fetch(fetchRequest)
        var customTrackers: [Tracker] = []
        try trackersCD?.forEach{ customTrackers.append( try self.trackers(from: $0) ) }
        return customTrackers
    }
    
    func trackers(from trackerCoreData: TrackerCoreData) throws -> Tracker {
        //  let timetable =  [0,1,2,3,4,5,6]
        guard let id = trackerCoreData.id,
              let name = trackerCoreData.name,
              let emoji = trackerCoreData.emoji,
              let colorHex = trackerCoreData.colorHex,
              let schedule = trackerCoreData.schedule as? [Int]
        else {
            throw TrackerStoreError.decodingError
        }
        
        return  Tracker(
            id: id,
            name:name,
            color: UIcolorMarshalling.color(from: colorHex),
            emoji: emoji,
            timetable: schedule
        )
    }
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if context.hasChanges {
            
            do {
                try context.save()
                print("deleted")
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
     
    }
    
}


enum TrackerStoreError: Error {
    case decodingError
}
