//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Dolnik Nikolay on 03.11.2023.
//

import UIKit
import CoreData

final class TrackerRecordStore: NSObject {
    
    private let entityName = "TrackerRecordCoreData"
    private let UIcolorMarshalling = UIColorMarshalling()
    private let context: NSManagedObjectContext
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerRecordCoreData> = {

        let fetchRequest = NSFetchRequest<TrackerRecordCoreData>(entityName: entityName)
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
    
    func addRecord(tracker: Tracker, recordDate: Date) throws {
      
        let record = TrackerRecordCoreData(context: context)
        record.id = tracker.id
        record.dateRecord = recordDate
        
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id" , ascending: true)]
        let result = try? context.fetch(fetchRequest)
        result?.forEach{ if $0.id == tracker.id {  record.tracker = $0  } }
        
         saveContext()
    }
    
    func deleteTracker(tracker: Tracker, recordDay: Date) throws {
        
        guard let r = fetchedResultsController.fetchedObjects else { return print("Record не удален") }
        r.forEach{
            if $0.id == tracker.id &&
                $0.dateRecord?.daysBetweenDate(toDate: recordDay) == 0 { context.delete($0)
            }
        }
        saveContext()
    }
    
    func getTrackerRecord(tracker: Tracker)-> Int {
        
        var record = 0
        let result = fetchedResultsController.fetchedObjects ?? []
        result.forEach{
            if $0.id == tracker.id { record += 1 }
        }
        return record
    }
    
    func getCompleteState(tracker: Tracker, date: Date)-> Bool {
        var completeState = false
        
        guard let result = fetchedResultsController.fetchedObjects else { return false }
        result.forEach{
            if $0.id == tracker.id &&
                $0.dateRecord?.daysBetweenDate(toDate: date) == 0 { completeState = true }
        }
        return completeState
    }
    
    func getCompletedTracker() -> Int? {
        return fetchedResultsController.fetchedObjects?.count ?? nil
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

extension TrackerRecordStore:  NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
     
    }
    
}
