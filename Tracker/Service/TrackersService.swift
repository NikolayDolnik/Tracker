//
//  TrackersService.swift
//  Tracker
//
//  Created by Dolnik Nikolay on 12.10.2023.
//

import Foundation
import UIKit

public protocol TrackersServiseProtocol {
    var categories:  [TrackerCategory] {get}
    var view: TrackersViewControllerProtocol? {get set}
    
    func findTrackers(text: String)-> [TrackerCategory]
    func changeDate(for day: Date)
    func addTracker(categoryNewName: String, name: String, emoji: String, color: UIColor, timetable: [Int] )
    func deleteTracker(for indexPath: IndexPath)
    func addTrackerRecord(for indexPath: IndexPath)
    func deleteTrackerRecord(for indexPath: IndexPath)
    func getTrackerRecord(for indexPath: IndexPath)-> Int
    func addTrackerEvent(categoryNewName: String, name: String, emoji: String, color: UIColor)
    func searchTrackers(text: String)
    var numberOfSections: Int { get }
    func numberOfRowsInSection(_ section: Int) -> Int
    func objectModel(at indexPath: IndexPath) -> TrackerCellModel?
    func nameforSection(_ section: Int) -> String?
}

final class TrackersService: TrackersServiseProtocol {
    
    static var shared = TrackersService()
    static let didChangeNotification = Notification.Name(rawValue: "TrackersServiceDidChange")
    private var currentDay = NSDate()
    private var visibleDay: Date?
    weak var view: TrackersViewControllerProtocol?
    private lazy var trackerStrore: TrackerStore = {
        let store = TrackerStore()
        store.delegate = self
        return store
    }()
    
    private var trackerRecordStore = TrackerRecordStore()
    var completedTrackers: Set<TrackerRecord> = []
    var categories: [TrackerCategory] = [
        TrackerCategory(
            categoreName: "First Service",
            trackers: [Tracker(
                id: UUID(),
                name: "First Tracker ВС",
                color: .selection10,
                emoji: "🌺",
                timetable: [WeekDay.monday.rawValue]
            )]
        ),
        TrackerCategory(
            categoreName: "Second",
            trackers: [
                Tracker(
                    id:  UUID(),
                    name: " Find Two Tracker ПН",
                    color: .selection14,
                    emoji: "🌺",
                    timetable: [WeekDay.monday.rawValue]
                ),
                Tracker(
                    id:  UUID(),
                    name: "Three blala Tracker",
                    color: .selection11,
                    emoji: "🌺",
                    timetable: [WeekDay.monday.rawValue]
                )]
        ),
        TrackerCategory(
            categoreName: "Second",
            trackers: [
                Tracker(
                    id:  UUID(),
                    name: "Two Tracker",
                    color: .selection14,
                    emoji: "😱",
                    timetable: [WeekDay.tuesday.rawValue]
                ),
                Tracker(
                    id:  UUID(),
                    name: "Three Tracker",
                    color: .selection11,
                    emoji: "🌺",
                    timetable: [WeekDay.tuesday.rawValue]
                )]
        ),
        TrackerCategory(
            categoreName: "Poisk",
            trackers: [
                Tracker(
                    id:  UUID(),
                    name: "Find Tracker",
                    color: .selection14,
                    emoji: "🐶",
                    timetable: [WeekDay.thursday.rawValue]
                ),
                Tracker(
                    id:  UUID(),
                    name: "Three Tracker",
                    color: .selection11,
                    emoji: "🌺",
                    timetable: [WeekDay.thursday.rawValue]
                )]
        )
    ]

    
    //MARK: - Search Trackers by date
    
    func changeDate(for day: Date)  {
        
        let numberOfDay = Calendar.current.component(.weekday, from: day ) - 1
        trackerStrore.predicateFetch(numberOfDay: numberOfDay)
        visibleDay = day
        view?.update()
    }
    
    //MARK: - Search Trackers by text
    
    func findTrackers(text: String)-> [TrackerCategory] {
        
        var newVisibleCategory = [TrackerCategory]()
        for category in categories {
            for (index, tracker) in category.trackers.enumerated(){
                if tracker.name.lowercased().contains(text) {
                    var newTrackers = [Tracker]()
                    newTrackers.append(category.trackers[index])
                    
                    let newTrackerCategory = TrackerCategory(categoreName: category.categoreName, trackers: newTrackers)
                    newVisibleCategory.append(newTrackerCategory)
                    newTrackers = []
                }
            }
        }
        return newVisibleCategory
    }
    
    func searchTrackers(text: String) {
        trackerStrore.predicateFetch(text: text)
        view?.update()
    }
    
    //MARK: - Add Trackers
    
    func addTracker(categoryNewName: String, name: String, emoji: String, color: UIColor, timetable: [Int] ) {
        let tracker = Tracker(
            id:  UUID(),
            name: name,
            color: color,
            emoji: emoji,
            timetable: timetable
        )
    
        try? trackerStrore.addTracker(tracker: tracker, categoryName: categoryNewName)
    }
    
    func addTrackerEvent(categoryNewName: String, name: String, emoji: String, color: UIColor) {
        let timetable =  [0,1,2,3,4,5,6]
        
        let tracker = Tracker(
            id:  UUID(),
            name: name,
            color: color,
            emoji: emoji,
            timetable: timetable
        )
        
        try? trackerStrore.addTracker(tracker: tracker, categoryName: categoryNewName)
    }
    
    
    //MARK: - Delete Trackers
    
    func deleteTracker(for indexPath: IndexPath){
        try? trackerStrore.deleteTracker(for: indexPath)
    }
    
    func isEnableCompleteButton() -> Bool {
        guard let visibleDay else { return true }
        return visibleDay.daysBetweenDate(toDate: currentDay as Date) >= 0 ? true : false
    }
    
    func getCompleteState(tracker: Tracker, date: Date)-> Bool {
        return trackerRecordStore.getCompleteState(tracker: tracker, date: date)
    }
    
    func deleteTrackerRecord(for indexPath: IndexPath){
        guard let recordDay = visibleDay,
              let tracker = trackerStrore.tracker(for: indexPath) else { return }
        
        try? trackerRecordStore.deleteTracker(tracker: tracker, recordDay: recordDay)
    }
    
    func addTrackerRecord(for indexPath: IndexPath){
        guard let recordDay = visibleDay,
              let tracker = trackerStrore.tracker(for: indexPath)
        else { return }
        
        try? trackerRecordStore.addRecord(tracker: tracker, recordDate: recordDay)
    }
    
    func getTrackerRecord(for indexPath: IndexPath)-> Int {
        guard let tracker = trackerStrore.tracker(for: indexPath)
        else { return 0 }
        
        return trackerRecordStore.getTrackerRecord(tracker: tracker)
    }
    
}


//MARK: - Store Delegate

extension TrackersService: StoreDelegateProtocol {
   
    func didUpdate(_ update: StoreUpdate) {
        view?.updateData(update)
    }
    
    
    var numberOfSections: Int {
        trackerStrore.fetchedResultsController.sections?.count ?? 0
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        trackerStrore.fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func objectModel(at indexPath: IndexPath) -> TrackerCellModel? {
       let trackerCore = trackerStrore.fetchedResultsController.object(at: indexPath)
        guard let tracker = try? trackerStrore.trackers(from: trackerCore) else { return nil }
        
        if visibleDay == nil {
            visibleDay = currentDay as Date
        }
        
        let trackerModell = TrackerCellModel(
            id: tracker.id,
            descriptionTracker: tracker.name,
            color: tracker.color,
            emoji: tracker.emoji,
            timetable: tracker.timetable,
            complete: getCompleteState(tracker: tracker, date: visibleDay!), // функция проверки на выполнение
            record: getTrackerRecord(for: indexPath), // функция проверки на рекорд
            isEnable: isEnableCompleteButton() // проверка доступности состояния кнопки
        )
        
        return trackerModell
    }
    
    func fetchTrackers() -> [Tracker] {
        guard let trackers = try? trackerStrore.fetchTrackers()  else { return [] }
        return trackers
    }
    
    func nameforSection(_ section: Int) -> String? {
        guard let trackerCoreData = trackerStrore.fetchedResultsController.sections?[section].objects?.first as? TrackerCoreData else { return nil }
        return trackerCoreData.category?.categoryName
        }
    
}
