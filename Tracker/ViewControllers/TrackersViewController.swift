//
//  ViewController.swift
//  Tracker
//
//  Created by Dolnik Nikolay on 03.10.2023.
//

import UIKit

final class TrackersViewController: UIViewController, UINavigationBarDelegate {
    
    var trackerService: TrackersServiseProtocol?
    var presenter: TrackersPresenterProtocol?
    var currentDay = Date()
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
    var search = UISearchTextField()
    var stubView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar()
        configUI()
        configPresenter()
        stubViewConfig()
        
        TrackersServiceObserver = NotificationCenter.default.addObserver(
            forName: TrackersService.didChangeNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                guard self != nil else { return}
                //self?.presenter?.visibleCategory = self?.trackerService?.categories ?? []
            }
        
    }
    
    func configPresenter(){
        searchController.searchBar.delegate = self
        
        trackerService = TrackersService.shared
        categories = trackerService!.categories
        
        presenter = TrackersPresenter()
        presenter?.visibleCategory =  trackerService?.categories ?? []
        collectionView.dataSource = presenter
        collectionView.delegate = presenter
        
    }
    
    
    func configUI(){
       
        view.backgroundColor = .whiteDayTracker
        view.addSubview(collectionView)
        view.addSubview(stubView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 24)
        ])
    }
    
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
            datePicker.date = Date()
            datePicker.addTarget(self, action: #selector(changeDatePicker), for: .valueChanged)
            
            let right = UIBarButtonItem(customView: datePicker)
            right.customView?.layer.cornerRadius = 16
            right.customView?.backgroundColor = .whiteDayTracker
            
            navBar.topItem?.setRightBarButton(right, animated: false)
            
            searchController.hidesNavigationBarDuringPresentation = false
            searchController.searchBar.placeholder = "Поиск"
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
    func stubViewConfig(){
        
        guard presenter!.visibleCategory .isEmpty else { return }
        let image = UIImageView(image: UIImage(named: "stub"))
        image.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        stubView.addSubview(image)
        stubView.addSubview(label)
        stubView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stubView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            stubView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            stubView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            stubView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            
            image.centerXAnchor.constraint(equalTo: stubView.centerXAnchor),
            image.centerYAnchor.constraint(equalTo: stubView.centerYAnchor),
            label.centerXAnchor.constraint(equalTo: stubView.centerXAnchor),
            label.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 8)

        ])
    }
    
}


//MARK: - DatePicker


extension TrackersViewController {
    @objc func changeDatePicker() {
        let timetable = Calendar.current.component(.weekday, from: datePicker.date )
        
        guard let trackerService = trackerService else {return}
        presenter?.newVisibleCategory(get: trackerService.changeDate(numberOfDay: timetable))
        collectionView.reloadData()
        print("change \(timetable)")
        
    }
}


//MARK: - SearchController

extension TrackersViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard searchText != "", searchText != " ", let trackerService = trackerService else { return }
    
        let text = searchText.lowercased()
        presenter?.newVisibleCategory(get: trackerService.findTrackers(text: text))
        collectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        guard let allCategory = trackerService?.categories else {return}
        presenter?.newVisibleCategory(get: allCategory)
        collectionView.reloadData()
    }
    
}
