//
//  Constants.swift
//  Tracker
//
//  Created by Dolnik Nikolay on 12.10.2023.
//

import Foundation

public enum identifier: String {
    case cell
    case header
    case footer
}

public enum WeekDay: Int {
    case monday = 1
    case tuesday = 2
    case wednesday = 3
    case thursday = 4
    case friday = 5
    case saturday = 6
    case sunday = 0
    
    static func getString(for count: Int) -> String {
        return WeekDay.init(rawValue: count)!.description
    }
    
    static func getShedule(for timetable: [Int]) -> String {
        var shedule: String = ""
        for i in timetable {
           shedule = shedule + getString(for: i) + " "
        }
        return shedule
    }
    
    static func getTimetable(for shedule: String) -> [Int] {
        var timetable: [Int] = []
        
        let components = shedule.components(separatedBy: " ")
        
        for i in components {
            for n in 0...6 {
                if WeekDay.init(rawValue: n)?.description == i {
                    guard let numberDay = WeekDay.init(rawValue: n) else { break }
                    timetable.append(numberDay.rawValue)
                }
            }
        }
        return timetable
    }
    
    static func getShortTimetable(for timetable: [Int]) -> String {
        let array = timetable.sorted(by: { $0 < $1 } )
        var string = ""
        
        if array.count == 7 {
            string = "Каждый день"
        } else {
            for i in array {
                string = string + getShortString(for: i) + ", "
            }
        }
        return string
    }
    
    static func getShortString(for count: Int) -> String {
        return WeekDay.init(rawValue: count)!.shortDescription
    }
    
   static var count: Int {
        return WeekDay.sunday.rawValue 
    }
    var description: String {
        switch self {
        case .monday:
            return  "Понедельник" // "monday"
        case .tuesday:
            return "Вторник" // "tuesday"
        case .wednesday:
            return "Среда" // "wednesday"
        case .thursday:
            return "Четверг" // "thursday"
        case .friday:
            return "Пятница" // "friday"
        case .saturday:
            return "Суббота" // "saturday"
        case .sunday:
            return "Воскресенье" // "sunday"
        }
    }
    
    var shortDescription: String {
        switch self {
        case .monday:
            return  "Пн" // "monday"
        case .tuesday:
            return "Вт" // "tuesday"
        case .wednesday:
            return "Ср" // "wednesday"
        case .thursday:
            return "Чт" // "thursday"
        case .friday:
            return "Пт" // "friday"
        case .saturday:
            return "Сб" // "saturday"
        case .sunday:
            return "Вс" // "sunday"
        }
    }
}

public enum State: String {
    case complete = "Property Done2"
    case addRecord = "ButtonTracker"
}

public struct StoreUpdate {
    let insertedIndexes: IndexSet
    let deletedIndexes: IndexSet
}
