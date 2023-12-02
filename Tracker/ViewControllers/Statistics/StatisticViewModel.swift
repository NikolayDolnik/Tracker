//
//  StatisticViewModel.swift
//  Tracker
//
//  Created by Dolnik Nikolay on 28.11.2023.
//

import UIKit

final class StatisticViewModel: StatisticsViewModelProtocol {
    
    private var recordStore: TrackerRecordStore
    
    @Observable
    var StatisticCells: [StatisticCellViewModel] = [
        StatisticCellViewModel(dayCount: 6, description: "Лучший период"),
        StatisticCellViewModel(dayCount: 2, description: "Идеальные дни"),
        StatisticCellViewModel(dayCount: 4, description: "Среднее значение")
    ]
    var StatisticCellsBind: Observable<[StatisticCellViewModel]> {
        get {
            self.$StatisticCells
        }
        set {
            Observable(wrappedValue: self.StatisticCells)
        }
    }

    convenience init() {
        self.init(categoriesStore: TrackerRecordStore())
    }

    init(categoriesStore: TrackerRecordStore) {
        self.recordStore = categoriesStore
        getTrackercompletedStat()
    }
    
    func getTrackercompletedStat(){
        guard let completedCount = recordStore.getCompletedTracker() else { return StatisticCells = [] }
        let model = StatisticCellViewModel(dayCount: completedCount, description: "Трекеров завершено")
        StatisticCells.insert(model, at: 2)
    }
    
    
}
