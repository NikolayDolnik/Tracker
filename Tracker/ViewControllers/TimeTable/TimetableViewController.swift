//
//  timetableiewController.swift
//  Tracker
//
//  Created by Dolnik Nikolay on 05.10.2023.
//

import Foundation
import UIKit

final class TimeTableViewController: UIViewController {
    
    var delegate: TimeTableDelegateProtocol?
    var timetable = [Int]()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Расписание"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .blackDayTracker
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var tableView: UITableView = {
        let t = UITableView()
        t.register(UITableViewCell.self, forCellReuseIdentifier: identifier.cell.rawValue)
        t.layer.cornerRadius = 16
        t.clipsToBounds = true
        t.layer.masksToBounds = true
        //t.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner]
        t.translatesAutoresizingMaskIntoConstraints = false
        return t
    }()
    
    var button = UIButton()
    
    init(timetable: [Int]? ){
        super.init(nibName: nil, bundle: nil)
        guard let timetable else { return }
        self.timetable = timetable
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    
    func config(){
        tableView.delegate = self
        tableView.dataSource = self
        button = configUIButton(button: button, title: "Готово", action: #selector(didTabCompleteButton))
        view.backgroundColor = .whiteDayTracker
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 525),
            
            button.heightAnchor.constraint(equalToConstant: 60),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
}

extension TimeTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier.cell.rawValue, for: indexPath)
        cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        var value = indexPath.row+1
        if value == 7 {
            value = 0
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 500)
        }
        cell.textLabel?.text = WeekDay.init(rawValue: value)?.description
        cell.backgroundColor = .backgroundDayTracker
        let switchUI = UISwitch()
        switchUI.onTintColor = .blueTracker
        switchUI.tag = indexPath.row
        switchUI.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        cell.accessoryView = switchUI
        
        if timetable.contains(WeekDay.init(rawValue: value)!.rawValue){
            switchUI.isOn = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
}

extension TimeTableViewController {
    
    @objc func switchChanged(_ sender: UISwitch!){
        var number = sender.tag + 1
        if number == 7 { number = 0 }
        
        if timetable.contains(where: { index in
            index == number
        }){
            timetable.removeAll { int in
                int == number
            }
        } else {
            timetable.append((number))
        }
    }
    
    @objc func didTabCompleteButton(){
        delegate?.addTimetable(timetable: timetable)
        self.dismiss(animated: true)
    }
}
