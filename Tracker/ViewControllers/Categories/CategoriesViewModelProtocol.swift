//
//  CategoriesViewModelProtocol.swift
//  Tracker
//
//  Created by Dolnik Nikolay on 26.11.2023.
//

import Foundation

protocol CategoriesViewModelProtocol: NewCategoryDelegateProtocol {
    
    var categories: [TrackerCategory] { get set }
    var categoriesBind: Observable<[TrackerCategory]> { get }
    var selectedCategory: String? { get set }
    func getCategoriesFromStore() -> [TrackerCategory]
    func deleteCategory(for indexPath: IndexPath)
    func setSelectedcategories(selectedCategory: String?)
}

