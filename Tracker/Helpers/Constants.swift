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
}

public enum State: String {
    case complete = "Property Done2"
    case addRecord = "ButtonTracker"
}
