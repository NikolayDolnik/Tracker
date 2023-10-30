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
    func findTrackers(text: String)-> [TrackerCategory]
    func changeDate(for day: Date) -> [TrackerCategory]
    func addTracker(categoryNewName: String, name: String, emoji: String, color: UIColor, timetable: [Int] )
    func createTrackerModel(tracker: Tracker) -> TrackerCellModel
    func addTrackerrecord(tracker: Tracker)
    func deleteTrackerRecord(tracker: Tracker)
    func getTrackerRecord(tracker: Tracker)-> Int
    func addTrackerEvent(categoryNewName: String, name: String, emoji: String, color: UIColor)
}

final class TrackersService: TrackersServiseProtocol {
    
    static var shared = TrackersService()
    static let didChangeNotification = Notification.Name(rawValue: "TrackersServiceDidChange")
    private var currentDay = NSDate()
    private var visibleDay: Date?
    var completedTrackers: Set<TrackerRecord> = []
    var categories: [TrackerCategory] = [
        TrackerCategory(
            categoreName: "First Service",
            trackers: [Tracker(
                id: UUID(),
                name: "First Tracker ВС",
                color: .selection10,
                emoji: "🌺",
                timetable: [WeekDay.sunday.rawValue]
            )]
        ),
        TrackerCategory(
            categoreName: "Second",
            trackers: [Tracker(
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
                        timetable: [WeekDay.friday.rawValue]
                       )]
        ),
        TrackerCategory(
            categoreName: "Second",
            trackers: [Tracker(
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
                        timetable: [WeekDay.monday.rawValue]
                       )]
        ),
        TrackerCategory(
            categoreName: "Poisk",
            trackers: [Tracker(
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
                        timetable: [WeekDay.saturday.rawValue]
                       )]
        )
    ]
    
    
    //MARK: - Search Trackers by date
    
    func changeDate(for day: Date) -> [TrackerCategory] {
        
        let numberOfDay = Calendar.current.component(.weekday, from: day ) - 1
        
        var newVisibleCategory = [TrackerCategory]()
        for category in categories {
            for (index, tracker) in category.trackers.enumerated(){
                if tracker.timetable.contains(numberOfDay){
                    var newTrackers = [Tracker]()
                    newTrackers.append(category.trackers[index])
                    
                    let newTrackerCategory = TrackerCategory(categoreName: category.categoreName, trackers: newTrackers)
                    newVisibleCategory.append(newTrackerCategory)
                    newTrackers = []
                }
            }
        }
        visibleDay = day
        return newVisibleCategory
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
    
    
    //MARK: - Add Trackers
    
    func addTracker(categoryNewName: String, name: String, emoji: String, color: UIColor, timetable: [Int] ) {
        var newVisibleCategory = [TrackerCategory]()
        let tracker = Tracker(
            id:  UUID(),
            name: name,
            color: color,
            emoji: emoji,
            timetable: timetable
        )
        var newArray = [Tracker]()
        
        for (index, category) in categories.enumerated() {
            if category.categoreName == categoryNewName {
                newArray = category.trackers
            } else {
                newVisibleCategory.append(categories[index])
            }
        }
        
        newArray.append(tracker)
        let newTrackerCategory = TrackerCategory(categoreName: categoryNewName, trackers: newArray)
        
        newVisibleCategory.append(newTrackerCategory)
        
        categories = newVisibleCategory
        NotificationCenter.default
            .post(
                name: TrackersService.didChangeNotification,
                object: self,
                userInfo: ["change": self.categories])
    }
    
    func addTrackerEvent(categoryNewName: String, name: String, emoji: String, color: UIColor) {
        let timetable =  [0,1,2,3,4,5,6] //Calendar.current.component(.weekday, from: currentDay as Date ) - 1
        
        var newVisibleCategory = [TrackerCategory]()
        let tracker = Tracker(
            id:  UUID(),
            name: name,
            color: color,
            emoji: emoji,
            timetable: timetable
        )
        var newArray = [Tracker]()
        
        for (index, category) in categories.enumerated() {
            if category.categoreName == categoryNewName {
                newArray = category.trackers
            } else {
                newVisibleCategory.append(categories[index])
            }
        }
        
        newArray.append(tracker)
        let newTrackerCategory = TrackerCategory(categoreName: categoryNewName, trackers: newArray)
        
        newVisibleCategory.append(newTrackerCategory)
        
        categories = newVisibleCategory
        NotificationCenter.default
            .post(
                name: TrackersService.didChangeNotification,
                object: self,
                userInfo: ["change": self.categories])
        
    }
    
    func createTrackerModel(tracker: Tracker) -> TrackerCellModel {
        
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
            record: getTrackerRecord(tracker: tracker), // функция проверки на рекорд
            isEnable: isEnableCompleteButton() // проверка доступности состояния кнопки
        )
        return trackerModell
    }
    
    func getTrackerRecord(tracker: Tracker)-> Int {
        
        var record = 0
        
        for completed in completedTrackers {
            if completed.id == tracker.id {
                record += 1
            }
        }
        return record
    }
    
    func isEnableCompleteButton() -> Bool {
        guard let visibleDay else { return true }
        return visibleDay.daysBetweenDate(toDate: currentDay as Date) >= 0 ? true : false
    }
    
    func getCompleteState(tracker: Tracker, date: Date)-> Bool {
        
        for completed in completedTrackers {
            if completed.id == tracker.id &&
                completed.dateRecord.daysBetweenDate(toDate: date) == 0 {
                print("\(completed.dateRecord.daysBetweenDate(toDate: date))")
                return true
            }
        }
        return false
    }
    
    func deleteTrackerRecord(tracker: Tracker){
        guard let recordDay = visibleDay else { return}
        
        for completed in completedTrackers {
            if completed.id == tracker.id &&
                completed.dateRecord.daysBetweenDate(toDate: recordDay) == 0 {
                let record = TrackerRecord(id: tracker.id, dateRecord: completed.dateRecord)
                completedTrackers.remove(record)
            }
        }
    }
    
    func addTrackerrecord(tracker: Tracker){
        guard let recordDay = visibleDay else { return}
        let record = TrackerRecord(id: tracker.id, dateRecord: recordDay)
        completedTrackers.insert(record)
    }
    
}
