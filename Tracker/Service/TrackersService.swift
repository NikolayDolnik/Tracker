//
//  TrackersService.swift
//  Tracker
//
//  Created by Dolnik Nikolay on 12.10.2023.
//

import Foundation
import UIKit

protocol TrackersServiseProtocol {
    var categories:  [TrackerCategory] {get}
    func findTrackers(text: String)-> [TrackerCategory]
    func changeDate(numberOfDay: Int) -> [TrackerCategory]
    func addTracker(categoryNewName: String, name: String, emoji: String, color: UIColor, timetable: [Int] )
}

final class TrackersService: TrackersServiseProtocol {
    
    static var shared = TrackersService()
    static let didChangeNotification = Notification.Name(rawValue: "TrackersServiceDidChange")
    
    var categories: [TrackerCategory] = [
        TrackerCategory(
            categoreName: "First Nax Service",
            trackers: [Tracker(
                id: UInt(),
                name: "First Tracker",
                color: .selection10,
                emoji: "🌺",
                timetable: [WeekDay.monday.rawValue]
            )]
        ),
        TrackerCategory(
            categoreName: "Second Nax",
            trackers: [Tracker(
                id: UInt(),
                name: " Find Two Tracker",
                color: .selection14,
                emoji: "🌺",
                timetable: [WeekDay.monday.rawValue]
            ),
                       Tracker(
                        id: UInt(),
                        name: "Three blala Tracker",
                        color: .selection11,
                        emoji: "🌺",
                        timetable: [WeekDay.friday.rawValue]
                       )]
        ),
        TrackerCategory(
            categoreName: "Second Nax",
            trackers: [Tracker(
                id: UInt(),
                name: "Two Tracker",
                color: .selection14,
                emoji: "🌺",
                timetable: [WeekDay.tuesday.rawValue]
            ),
                       Tracker(
                        id: UInt(),
                        name: "Three Tracker",
                        color: .selection11,
                        emoji: "🌺",
                        timetable: [WeekDay.monday.rawValue]
                       )]
        ),
        TrackerCategory(
            categoreName: "Poisk Nax",
            trackers: [Tracker(
                id: UInt(),
                name: "Find Tracker",
                color: .selection14,
                emoji: "🌺",
                timetable: [WeekDay.thursday.rawValue]
            ),
                       Tracker(
                        id: UInt(),
                        name: "Three Tracker",
                        color: .selection11,
                        emoji: "🌺",
                        timetable: [WeekDay.saturday.rawValue]
                       )]
        )
    ]
    
    
    //MARK: - Search Trackers by date
    
    func changeDate(numberOfDay: Int) -> [TrackerCategory] {
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
        
//        NotificationCenter.default
//            .post(
//                name: TrackersService.didChangeNotification,
//                object: self,
//                userInfo: ["change": self.categories])
        
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
        
        print("Cоздание категории")
        var newArray: [Tracker] = []
        
        let tracker = Tracker(
            id: UInt(),
            name: "First Tracker",
            color: .selection14,
            emoji: "🌺",
            timetable: [WeekDay.monday.rawValue]
        )
        var indexCategory: Int
        
        for (index, category) in categories.enumerated(){
            if category.categoreName == categoryNewName {
                newArray = categories[index].trackers
                indexCategory = index
            }
        }
        newArray.append(tracker)
        
        
        var newTrackerCategory = TrackerCategory(categoreName: categoryNewName, trackers: newArray)
        // categories.remove(at: indexCategory)
        categories.append(newTrackerCategory)
    }
    
    //    func addTracker(_ tracker: Tracker, at category: TrackerCategory) {
    //            var trackers = category.trackers
    //
    //            trackers.append(tracker)
    //
    //            let newCategory = TrackerCategory(name: category.name, trackers: trackers)
    //            var categories = self.categories
    //
    //            if let index = categories.firstIndex(where: { $0.name == category.name } ) {
    //                categories[index] = newCategory
    //            } else {
    //                categories.append(newCategory)
    //            }
    //            self.categories = categories
    //        }
    
    //    func trackerCategory(name: String, tracker: Tracker)-> TrackerCategory {
    //
    //        return TrackerCategory(categoreName: <#String#>, trackers: <#[Tracker]#>)
    //    }
  
}
