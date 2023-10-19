//
//  CreateViewController.swift
//  Tracker
//
//  Created by Dolnik Nikolay on 03.10.2023.
//

import Foundation
import UIKit

final class CreateViewController: UIViewController {
    
    var habitsButton = UIButton()
    var eventsButton = UIButton()
   
    lazy var titleLabel: UILabel = {
         let label = UILabel()
         label.text = "Создание трекера"
         label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
         label.textColor = .blackDayTracker
         label.translatesAutoresizingMaskIntoConstraints = false
         return label
     }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    func config(){
        habitsButton = configUIButton(button: habitsButton, title: "Привычка", action: #selector(didTapHabitsButton))
        eventsButton = configUIButton(button: eventsButton, title: "Нерегулярные событие", action: #selector(didTapEventsButton))
        view.backgroundColor = .whiteDayTracker
        view.addSubview(titleLabel)
        view.addSubview(habitsButton)
        view.addSubview(eventsButton)
       
        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            habitsButton.heightAnchor.constraint(equalToConstant: 60),
            habitsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 280),
            habitsButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            habitsButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            eventsButton.heightAnchor.constraint(equalToConstant: 60),
            eventsButton.topAnchor.constraint(equalTo: habitsButton.bottomAnchor, constant: 16),
            eventsButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            eventsButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
        
    }
    
    
    @objc func didTapHabitsButton(){
        let vc = HabitsViewController()
        present(vc, animated: true)
        }
        
    @objc func didTapEventsButton(){
        let vc = EventViewController()
        present(vc, animated: true)
        }
}
