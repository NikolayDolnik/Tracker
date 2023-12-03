//
//  StatisticsViewModelProtocol.swift
//  Tracker
//
//  Created by Dolnik Nikolay on 27.11.2023.
//

import Foundation

protocol StatisticsViewModelProtocol {
    var StatisticCells: [StatisticCellViewModel] { get set }
    var StatisticCellsBind: Observable<Bool> { get set }
    var statisticIsEmpty: Bool { get }
}
