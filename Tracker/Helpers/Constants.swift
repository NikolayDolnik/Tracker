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
    case sunday = 7
}

public enum State: String {
    case complete = "PropertyDone"
    case addRecord = "ButtonTracker"
}
