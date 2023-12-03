//
//  StatisticCellViewModel.swift
//  Tracker
//
//  Created by Dolnik Nikolay on 27.11.2023.
//

import UIKit

final class StatisticCellViewModel {
    var dayCount: Int
    var description: String
    
    init(dayCount: Int, description: String) {
        self.dayCount = dayCount
        self.description = description
    }
    
}
