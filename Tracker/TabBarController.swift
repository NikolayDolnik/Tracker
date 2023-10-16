//
//  TabBarController.swift
//  Tracker
//
//  Created by Dolnik Nikolay on 03.10.2023.
//

import Foundation
import UIKit

final class TabBarController: UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func config(){
        self.tabBar.backgroundColor = .whiteDayTracker
        tabBar.layer.borderWidth = 1
        tabBar.layer.borderColor = UIColor.grayTracker.cgColor
        
        let navigationController = UINavigationController(rootViewController: TrackersViewController())
        
       
        navigationController.tabBarItem = UITabBarItem(
            title: "Tрекеры",
            image: UIImage(named: "trackers"),
            selectedImage: nil
        )
        let statisticsViewController = StatisticsViewController()
        statisticsViewController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(named: "stats"),
            selectedImage: nil
        )
        self.viewControllers = [navigationController, statisticsViewController]
    }
    
}
