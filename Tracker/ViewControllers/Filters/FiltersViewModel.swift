//
//  FiltersViewModel.swift
//  Tracker
//
//  Created by Dolnik Nikolay on 28.11.2023.
//

import UIKit

final class FilersViewModel: FiltersViewModelProtocol {
    
    @Observable
    var selectedFilters: String
    var selectedDay: Date
    var filtersBind: Observable<String> {
        get {
            self.$selectedFilters
        }
        set {
            Observable(wrappedValue: self.$selectedFilters)
        }
    }
    var filters: [String]
    private let delegate: TrackersServiseProtocol

    convenience init(selectedDay: Date, selectedFilters: String) {
        self.init(filters: filtersMok, selectedFilters: selectedFilters, selectedDay: selectedDay, delegate: TrackersService.shared)
    }

    init(filters: [String], selectedFilters: String, selectedDay: Date, delegate: TrackersServiseProtocol) {
        self.filters = filters
        self.selectedFilters = selectedFilters
        self.selectedDay = selectedDay
        self.delegate = delegate
    }
    
    func setSelectedFilters(selectedFilters: String){
        self.selectedFilters = selectedFilters
    }
    
    func tapFilters(index: IndexPath){
        self.selectedFilters = filters[index.row]
        delegate.setFilters(filter: selectedFilters, selectedDay: selectedDay)
    }

}


let filtersMok = [
    "Все трекеры",
    "Трекеры на сегодня",
    "Завершенные",
    "Не завершенные",
]
