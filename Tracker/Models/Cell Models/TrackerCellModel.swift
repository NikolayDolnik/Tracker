//
//  TrackerCellModel.swift
//  Tracker
//
//  Created by Dolnik Nikolay on 17.10.2023.
//

import Foundation
import UIKit

public struct TrackerCellModel {
    let id:  UUID
    let descriptionTracker: String
    let color: UIColor
    let emoji: String
    let timetable: [Int]
    var complete: Bool
    var record: Int
    var isEnable: Bool
    var categoryName: String?
    var pincategory = "Закрепленные"
    var isPinned: Bool = false
    var index: IndexPath?
}
