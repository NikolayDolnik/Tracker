//
//  StatisticViewModel.swift
//  Tracker
//
//  Created by Dolnik Nikolay on 28.11.2023.
//

import UIKit

final class StatisticViewModel: StatisticsViewModelProtocol {
    
    private var recordStore: TrackerRecordStore
    
    
    var StatisticCells: [StatisticCellViewModel] = [
        StatisticCellViewModel(dayCount: 6, description: "Лучший период"),
        StatisticCellViewModel(dayCount: 2, description: "Идеальные дни"),
        StatisticCellViewModel(dayCount: 4, description: "Среднее значение")
    ]
    var StatisticCellsBind: Observable<Bool> {
        get {
            self.$statisticIsEmpty
        }
        set {
            Observable(wrappedValue: self.statisticIsEmpty)
        }
    }
    
    @Observable
    var statisticIsEmpty: Bool = true
    
    convenience init() {
        self.init(categoriesStore: TrackerRecordStore())
    }
    
    init(categoriesStore: TrackerRecordStore) {
        self.recordStore = categoriesStore
        recordStore.delegate = self
        getTrackercompletedStat()
    }
    
    func getTrackercompletedStat(){
        guard let completedCount = recordStore.getCompletedTracker(),
        completedCount != 0 else { return statisticIsEmpty = true }
        print("Статистика по завершенным треккерам -  \(completedCount)")
        let model = StatisticCellViewModel(dayCount: completedCount, description: "Трекеров завершено")
        statisticIsEmpty = false
        StatisticCells.insert(model, at: 2)
    }
}


extension StatisticViewModel: StoreDelegateProtocol {
    func didUpdate(_ update: StoreUpdate) {
        getTrackercompletedStat()
    }
    
    
}
