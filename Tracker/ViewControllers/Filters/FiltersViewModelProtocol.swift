//
//  FiltersViewModelProtocol.swift
//  Tracker
//
//  Created by Dolnik Nikolay on 28.11.2023.
//

import Foundation

protocol FiltersViewModelProtocol {
    var selectedFilters: String { get }
    var filtersBind: Observable<String> { get }
    var filters: [String] { get }
    func setSelectedFilters(selectedFilters: String)
    func tapFilters(index: IndexPath)
}
