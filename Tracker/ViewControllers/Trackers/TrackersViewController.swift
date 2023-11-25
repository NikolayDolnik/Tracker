//
//  ViewController.swift
//  Tracker
//
//  Created by Dolnik Nikolay on 03.10.2023.
//

import UIKit

final class TrackersViewController: UIViewController, UINavigationBarDelegate, TrackersViewControllerProtocol {
    
    var trackerService: TrackersServiseProtocol?
    var presenter: TrackersPresenterProtocol?
    let currentDay = NSDate()
    var categories = [TrackerCategory]()
    var completeTrackers = [TrackerRecord]()
    
    private let datePicker = UIDatePicker()
    private let searchController = UISearchController()
    private var TrackersServiceObserver: NSObjectProtocol?
    var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.register(TrackersCollectionViewCell.self, forCellWithReuseIdentifier: identifier.cell.rawValue)
        collection.register(SupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifier.header.rawValue)
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    private var search = UISearchTextField()
    private var stubsView = StubView()
    
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar()
        configUI()
        configPresenter()
        changeDatePicker()
        view.addTapGestureToHideKeyboard()
    }
    
    
    //MARK: - Congfiguration
    
    func configPresenter(){
        searchController.searchBar.delegate = self
        
        trackerService = TrackersService.shared
        trackerService?.view = self
        categories = trackerService!.categories
        
        presenter = TrackersPresenter()
        presenter?.visibleCategory =  trackerService?.categories ?? []
        presenter?.trackerService = trackerService
        presenter?.view = self
        collectionView.dataSource = presenter
        collectionView.delegate = presenter
        
    }
    
    
    func configUI(){
        
        view.backgroundColor = .whiteDayTracker
        view.addSubview(collectionView)
        view.addSubview(stubsView)
        stubsView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 24),
            stubsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            stubsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            stubsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            stubsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24)
        ])
        stubsView.isHidden = false
    }
    
    
    //MARK: - Navigation Bar
    
    func navigationBar(){
        
        if let navBar = navigationController?.navigationBar {
            navBar.topItem?.title = "Трекеры"
            navBar.prefersLargeTitles = true
            let leftButton = UIBarButtonItem(image: UIImage(named: "addTracker"), style: .done, target: self, action: #selector(addTrackers))
            leftButton.tintColor = .blackDayTracker
            navBar.topItem?.setLeftBarButton(leftButton, animated: false)
            
            datePicker.backgroundColor = .lightGrayTracker
            datePicker.preferredDatePickerStyle = .compact
            datePicker.datePickerMode = .date
            datePicker.locale = Locale(identifier: "ru-RU")
            datePicker.date = Date()
            datePicker.addTarget(self, action: #selector(changeDatePicker), for: .valueChanged)
            
            let right = UIBarButtonItem(customView: datePicker)
            right.customView?.layer.cornerRadius = 16
            right.customView?.backgroundColor = .whiteDayTracker
            
            navBar.topItem?.setRightBarButton(right, animated: false)
            
            searchController.hidesNavigationBarDuringPresentation = false
            searchController.searchBar.placeholder = "Поиск"
            searchController.searchBar.setValue("Отменить", forKey: "cancelButtonText")
            searchController.searchBar.accessibilityLanguage = "ru-RU"
            
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
            
        }
        
    }
    
    @objc func addTrackers(){
        let createVC = CreateViewController()
        self.present(createVC, animated: true)
    }
}

//MARK: - StubView

extension TrackersViewController {
    
    func stubViewConfig(stubs: Stubs){
        print(collectionView.numberOfSections)
        guard
            collectionView.numberOfSections == 0
           // collectionView.numberOfItems(inSection: 0) == 0
        else { return  stubsView.isHidden = true }
        
        stubsView.stubViewConfig(stubs: stubs)
        stubsView.isHidden = false
    }
}


//MARK: - UpdateData

extension TrackersViewController {
    
    func update() {
        collectionView.reloadData()
        stubViewConfig(stubs: Stubs.date)
    }
    
    func updateData(_ update: StoreUpdate) {
        collectionView.performBatchUpdates{
            let insertedIndexPaths = update.insertedIndexes.map { IndexPath(item: $0, section: 0) }
            let deletedIndexPaths = update.deletedIndexes.map { IndexPath(item: $0, section: 0) }
            collectionView.deleteItems(at: deletedIndexPaths)
            collectionView.insertItems(at: insertedIndexPaths)
        }
        stubViewConfig(stubs: Stubs.date)
    }

}

//MARK: - DatePicker


extension TrackersViewController {
    @objc func changeDatePicker() {
        
        guard let trackerService = trackerService else {return}
        trackerService.changeDate(for: datePicker.date)
        stubViewConfig(stubs: Stubs.date)
    }
}


//MARK: - SearchController

extension TrackersViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard searchText != "", searchText != " ", let trackerService = trackerService else { return }
        
        let text = searchText.lowercased()
        trackerService.searchTrackers(text: text)
        stubViewConfig(stubs: Stubs.search)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        changeDatePicker()
        collectionView.reloadData()
    }
    
}


//MARK: - TrackersCollectionViewCellDelegate

extension TrackersViewController: TrackersCollectionViewCellDelegate {
    
    @objc func didTapCompleteButton(_ cell: TrackersCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell),
              let trackerService else {return}
        
        cell.changeState(state: cell.completeState)
        switch cell.completeState {
        case true:
            trackerService.addTrackerRecord(for: indexPath)
            
            cell.dayCountLable.text = "\(trackerService.getTrackerRecord(for: indexPath)) дней"
        case false:
            trackerService.deleteTrackerRecord(for: indexPath)
            cell.dayCountLable.text = "\(trackerService.getTrackerRecord(for: indexPath) ) дней"
        }
    }
}


