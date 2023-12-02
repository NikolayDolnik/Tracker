//
//  ViewController.swift
//  Tracker
//
//  Created by Dolnik Nikolay on 03.10.2023.
//

import UIKit

final class TrackersViewController: UIViewController {
    
    lazy var titleLabel: UILabel = {
         let label = UILabel()
         label.text = "Трекеры"
         label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
         label.textColor = .blackDayTracker
         label.translatesAutoresizingMaskIntoConstraints = false
         return label
     }()
    
    var search = UISearchTextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar()
        config()
    }
    
    func config(){
        view.backgroundColor = .whiteDayTracker
        view.addSubview(titleLabel)
        view.addSubview(search)
//        let navBar = CustomNavigationBar()
//        navBar.creacte()
//        view.addSubview(navBar)
        search.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(equalToConstant: 41),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            search.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            search.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor)
        ])
    }
    
    func navigationBar(){
        //var createButton = UIBarItem(image: UIImage(named: "addTracker"), style: .done, target: .none, action: nil)
//        navigationController?.title = "asdasf"
//        navigationController?.navigationBar.tintColor = .blackDayTracker
//        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "addTracker"), style: .done, target: self, action: nil)
        
    }
    
     
}

