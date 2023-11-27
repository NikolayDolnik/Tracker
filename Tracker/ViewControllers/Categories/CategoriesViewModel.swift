//
//  CategoriesViewModel.swift
//  Tracker
//
//  Created by Dolnik Nikolay on 23.11.2023.
//

import UIKit

final class CategoriesViewModel: CategoriesViewModelProtocol {
    
    private var categoriesStore: TrackerCategoryStore
    
    @Observable
    var categories: [TrackerCategory] = []
    var categoriesBind: Observable<[TrackerCategory]> {
        get {
            self.$categories
        }
        set {
            Observable(wrappedValue: self.categories)
        }
    }
    
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
    
    func setSelectedcategories(selectedCategory: String?){
        self.selectedCategory = selectedCategory
    }
    
    func deleteCategory(for indexPath: IndexPath) {
        try? categoriesStore.deleteTrackerCategory(for: indexPath)
        categories = getCategoriesFromStore()
    }

   func getCategoriesFromStore() -> [TrackerCategory] {
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
        selectedCategory = categoryName
    }
}
