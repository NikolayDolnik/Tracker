//
//  ViewController.swift
//  Tracker
//
//  Created by Dolnik Nikolay on 03.10.2023.
//

import UIKit

final class TrackersViewController: UIViewController, UINavigationBarDelegate, TrackersViewControllerProtocol {
    
    private var trackersTitle = "Трекеры"
    private var filterTitle = "Фильтры"
    private  var analyticsService = AnalyticsService.shared
    var trackerService: TrackersServiseProtocol?
    var presenter: TrackersPresenterProtocol?
    let currentDay = NSDate()
    
    private let datePicker = UIDatePicker()
    private let searchController = UISearchController()
    private var TrackersServiceObserver: NSObjectProtocol?
    var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.register(TrackersCollectionViewCell.self, forCellWithReuseIdentifier: identifier.cell.rawValue)
        collection.register(SupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifier.header.rawValue)
        collection.alwaysBounceVertical = true
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    private var search = UISearchTextField()
    private var stubsView = StubView()
    private lazy var filterButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapFilters), for: .touchUpInside)
        button.setTitle(filterTitle, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        button.backgroundColor = .blueTracker
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar()
        configUI()
        configPresenter()
        changeDatePicker()
        view.addTapGestureToHideKeyboard()
        analyticsService.report(event: "open", params: [ Event.typeEvent.rawValue : Event.open.rawValue , Event.typeScreen.rawValue : main])
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        analyticsService.report(event: "close", params: [ Event.typeEvent.rawValue : Event.close.rawValue , Event.typeScreen.rawValue : main])
    }
    
    //MARK: - Congfiguration
    
    func configPresenter(){
        searchController.searchBar.delegate = self
        
        trackerService = TrackersService.shared
        trackerService?.view = self
        
        presenter = TrackersPresenter()
        presenter?.trackerService = trackerService
        presenter?.view = self
        collectionView.dataSource = presenter
        collectionView.delegate = presenter
        
    }
    
    
    func configUI(){
        
        view.backgroundColor = .whiteDayTracker
        collectionView.backgroundColor = .whiteDayTracker
        collectionView.contentInset.bottom = 60
        
        view.addSubview(collectionView)
        view.addSubview(stubsView)
        view.addSubview(filterButton)
        stubsView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 24),
            
            filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterButton.heightAnchor.constraint(equalToConstant: 50),
            filterButton.widthAnchor.constraint(equalToConstant: 114),
            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
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
            navBar.topItem?.title = trackersTitle.localized()
            navBar.prefersLargeTitles = true
            let leftButton = UIBarButtonItem(image: UIImage(named: "addTracker"), style: .done, target: self, action: #selector(addTrackers))
            leftButton.tintColor = .blackDayTracker
            navBar.topItem?.setLeftBarButton(leftButton, animated: false)
            
            datePicker.backgroundColor = .lightGrayTracker
            datePicker.preferredDatePickerStyle = .compact
            datePicker.datePickerMode = .date
            datePicker.locale = Locale.current
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
        
        analyticsService.report(event: "tapAddTrackers", params: [ Event.typeEvent.rawValue : Event.click.rawValue , Event.typeScreen.rawValue : main, Event.typeItem.rawValue : "add_track"])
        
        self.present(createVC, animated: true)
    }
    
    @objc func didTapFilters(){
        guard let trackerService else { return }
        let filtersVC = FiltersViewController(viewModel: FilersViewModel(selectedDay: datePicker.date, selectedFilters: trackerService.selectedFilter))
        analyticsService.report(event: "tapFilters", params: [ Event.typeEvent.rawValue : Event.click.rawValue , Event.typeScreen.rawValue : main, Event.typeItem.rawValue : "filter"])
        
        self.present(filtersVC, animated: true)
    }
}

//MARK: - StubView

extension TrackersViewController {
    
    func stubViewConfig(stubs: Stubs){
        guard
            collectionView.numberOfSections == 0
                // collectionView.numberOfItems(inSection: 0) == 0
        else {
            stubsView.isHidden = true
            filterButton.isHidden = false
            return
        }
        
        stubsView.stubViewConfig(stubs: stubs)
        stubsView.isHidden = false
        filterButton.isHidden = true
    }
}


//MARK: - UpdateData

extension TrackersViewController {
    
    func update() {
        collectionView.reloadData()
        stubViewConfig(stubs: Stubs.date)
        
        guard let day = trackerService?.visibleDay else { return }
        datePicker.date = day
        
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
        trackerService.searchTrackers(text: text, day: datePicker.date)
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
        analyticsService.report(event: "tapTrack", params: [ Event.typeEvent.rawValue : Event.click.rawValue , Event.typeScreen.rawValue : main, Event.typeItem.rawValue : "track"])
        
        guard let indexPath = collectionView.indexPath(for: cell),
              let trackerService else {return}
        
        cell.changeState(state: cell.completeState)
        
        switch cell.completeState {
        case true:
            trackerService.addTrackerRecord(for: indexPath)
        case false:
            trackerService.deleteTrackerRecord(for: indexPath)
        }
    }
}

extension TrackersViewController {
    
    func pinTracker(index: IndexPath){
        guard let model = trackerService?.objectModel(at: index),
              let cell = collectionView.cellForItem(at: index) as? TrackersCollectionViewCell else {return }
        cell.isPinned(state: !model.isPinned)
        trackerService?.pinnedTracker(index: index, state: model.isPinned)
    }
    
    func editTracker(index: IndexPath){
        analyticsService.report(event: "tapEdit", params: [ Event.typeEvent.rawValue : Event.click.rawValue , Event.typeScreen : main, Event.typeItem.rawValue : "edit"])
        
        guard let model = trackerService?.objectModel(at: index) else { return }
        let viewModel = EditTrackersViewModel(model: model,selectedCategory: model.categoryName ?? "")
        let vc = EditTrackersViewController(viewModel: viewModel)
        self.present(vc, animated: true)
    }
    
    func tapDelete(index: IndexPath){
        analyticsService.report(event: "tapDelete", params: [ Event.typeEvent.rawValue : Event.click.rawValue , Event.typeScreen.rawValue : main, Event.typeItem.rawValue : "delete"])
        
        let alert = UIAlertController(title: "Уверены что хотите удалить трекер?", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Удалить",
                                      style: .destructive,
                                      handler: {_ in
            self.trackerService?.deleteTracker(for: index)
        }))
        alert.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    
}

