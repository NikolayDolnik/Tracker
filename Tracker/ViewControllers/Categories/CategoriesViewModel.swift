//
//  CategoriesViewModel.swift
//  Tracker
//
//  Created by Dolnik Nikolay on 23.11.2023.
//

import UIKit

final class CategoriesViewModel {
    
    private let categoriesStore: TrackerCategoryStore
    
    @Observable
    private (set) var categories: [TrackerCategory] = []
    
    @Observable
    var selectedCategory: String?

    convenience init() {
        self.init(categoriesStore: TrackerCategoryStore())
    }

    init(categoriesStore: TrackerCategoryStore) {
        self.categoriesStore = categoriesStore
        categoriesStore.delegate = self
        categories = getCategoriesFromStore()
    }
    
    func deleteCategory(for indexPath: IndexPath) {
        try? categoriesStore.deleteTrackerCategory(for: indexPath)
        categories = getCategoriesFromStore()
    }

    private func getCategoriesFromStore() -> [TrackerCategory] {
        guard let categories = try? categoriesStore.fetchTrackerCategories()  else { return [] }
        return categories
    }

}

extension CategoriesViewModel: TrackerCategoryStoreDelegate {
    func storeDidUpdate(_ store: TrackerCategoryStore) {
        categories = getCategoriesFromStore()
    }
}

extension CategoriesViewModel: NewCategoryDelegateProtocol {
    func addTrackerCategory(categoryName: String) {
        try? categoriesStore.addTrackerCategory(categoryName: categoryName)
    }
}
