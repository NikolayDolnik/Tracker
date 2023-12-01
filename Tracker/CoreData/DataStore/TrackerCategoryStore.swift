//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Dolnik Nikolay on 03.11.2023.
//

import UIKit
import CoreData

protocol TrackerCategoryStoreDelegate: AnyObject {
    func storeDidUpdate(_ store: TrackerCategoryStore)
}

final class TrackerCategoryStore: NSObject {
    
    var delegate: TrackerCategoryStoreDelegate?
    private let entityName = "TrackerCategoryCoreData"
    private let UIcolorMarshalling = UIColorMarshalling()
    private var pinnedCategory = "Закрепленные"
    private let context: NSManagedObjectContext
    var trackerCategoriesCoreData: [TrackerCategoryCoreData] {
       return self.fetchedResultsController.fetchedObjects ?? []
    }
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData> = {

        let fetchRequest = NSFetchRequest<TrackerCategoryCoreData>(entityName: entityName)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "categoryName", ascending: false)]
        
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
    
    func fetchTrackerCategories() throws -> [TrackerCategory] {
        let fetchRequest = NSFetchRequest<TrackerCategoryCoreData>(entityName: entityName)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "categoryName", ascending: false)]
        
        //Добавить предикат, что бы скрыть закрепленную категорию
        fetchRequest.predicate =  NSPredicate(format: "%K != %@",
                                              #keyPath(TrackerCategoryCoreData.categoryName),
                                              pinnedCategory)
        
        try? fetchedResultsController.performFetch()
        
        let categoriesCD = try? context.fetch(fetchRequest)
        var trackerCategories: [TrackerCategory] = []
        try categoriesCD?.forEach{ trackerCategories.append( try self.getCategories(from: $0) ) }
        return trackerCategories
    }
    
    func fetchTrackerCategory(categoryName: String) throws -> TrackerCategoryCoreData? {
        print("Ищем категорию - \(categoryName)")
        let predicate = NSPredicate(format: "%K CONTAINS[cd] %@",
                                    #keyPath(TrackerCategoryCoreData.categoryName),
                                    categoryName)
        
        fetchedResultsController.fetchRequest.predicate = predicate
        do {
            let results = try context.fetch( fetchedResultsController.fetchRequest)
            print("Нашли категорию - \(results)")
            return results.first
        } catch {
            return nil
        }
//
//        let categories = try context.fetch(fetchedResultsController.fetchRequest)
//        print("Нашли категорию - \(categories[0].categoryName)")
//        guard let category = categories.first else { return nil }
//        return category
    }
    
    func getCategories(from TrackerCategoryCoreData: TrackerCategoryCoreData) throws -> TrackerCategory {
   
        guard
              let name = TrackerCategoryCoreData.categoryName
        else {
            throw TrackerStoreError.decodingError
        }
        
        return  TrackerCategory(
            categoreName: name,
            trackers: []
        )
    }
    
    func addTrackerCategory(categoryName: String) throws {
        let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
        trackerCategoryCoreData.categoryName = categoryName
        saveContext()
    }
    
    func editCategory(oldCategoryName:String, newCategoryName: String) throws {
        var category = try? fetchTrackerCategory(categoryName: oldCategoryName)
        if category != nil {
            category?.categoryName = newCategoryName
        } else {
            return
        }
        saveContext()
    }

   
    func addTrackerToCategory(tracker: TrackerCoreData, categoryName: String) throws {
        
        if let trackerCategory = try? fetchTrackerCategory(categoryName: categoryName)
        {
            tracker.category = trackerCategory
            trackerCategory.addToTracker(tracker)
        } else {
            // создать категорию
            try? addTrackerCategory(categoryName: categoryName)
            tracker.category = trackerCategoriesCoreData.first(where: {$0.categoryName == categoryName })
        }
        saveContext()
    }
    
    func editTrackerToCategory(tracker: TrackerCoreData, newCategoryName: String) throws {
        guard let oldCategory = tracker.category?.categoryName else { return }
        
        //Удаляем трекер из старой категории
        let trackerCategory = try? fetchTrackerCategory(categoryName: oldCategory )
        print("Удаляем трекер из - \(trackerCategory?.categoryName!)")
        trackerCategory?.removeFromTracker(tracker)
        
       //Проверяем создана ли новая категория
        let trackerNewCategory = try? fetchTrackerCategory(categoryName: newCategoryName)
        
        if let name = trackerNewCategory?.categoryName {
            // Добавляем в новую
            print("Добавляем трекер в - \(name)")
            tracker.category = trackerNewCategory
            trackerNewCategory?.addToTracker(tracker)
        } else {
            //Cоздать новую категорию и добавить трекер
            let trackerCategory = TrackerCategoryCoreData(context: context)
            trackerCategory.categoryName = newCategoryName
            tracker.category = trackerCategory
            trackerCategory.addToTracker(tracker)
        }
        
        saveContext()
    }
    
    
    
    func getTrackerCategory(for indexPath: IndexPath) -> TrackerCategory? {
        return try? getCategories(from: fetchedResultsController.object(at: indexPath))
    }
    
    func deleteTrackerCategory(for indexPath: IndexPath) throws {
        let category = fetchedResultsController.object(at: indexPath)
        context.delete(category)
        saveContext()
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

extension TrackerCategoryStore:  NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.storeDidUpdate(self)
    }
    
}

