//
//  EditTrackersViewModel.swift
//  Tracker
//
//  Created by Dolnik Nikolay on 30.11.2023.
//

import UIKit

final class EditTrackersViewModel: EditViewModelProtocol, StoreDelegateProtocol {
    
    private var trackerStore: TrackerStore
    var model: TrackerCellModel
    
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
    var selectedCategory: String

    convenience init(model: TrackerCellModel, selectedCategory: String) {
        self.init(trackerStore: TrackerStore(), model: model, selectedCategory: selectedCategory )
    }

    init(trackerStore: TrackerStore, model: TrackerCellModel, selectedCategory: String) {
        self.model = model
        self.trackerStore = trackerStore
        self.selectedCategory = selectedCategory
        trackerStore.delegate = self
        
    }
  
    func didUpdate(_ update: StoreUpdate) {
     //
    }
    
    
}

