//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Dolnik Nikolay on 03.10.2023.
//

import Foundation
import UIKit

final class StatisticsViewController: UIViewController {
    
    private var stubsView = StubView()
    private var viewModel: StatisticsViewModelProtocol
    
    private let tableView: UITableView = {
         let t = UITableView()
         t.register(StatisticCell.self, forCellReuseIdentifier: identifier.cell.rawValue)
         t.layer.cornerRadius = 16
        //t.clipsToBounds = true
         t.layer.masksToBounds = true
         t.backgroundColor = .clear
         t.translatesAutoresizingMaskIntoConstraints = false
         return t
     }()
    
    init(){
        self.viewModel = StatisticViewModel() 
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar()
        configUI()
        stubViewConfig(stubs: Stubs.statistic)
    }
    
    func configUI(){
        viewModel.StatisticCellsBind.bind(action: { [weak self] _ in
                        guard let self else { return }
                        self.tableView.reloadData()
                        self.stubViewConfig(stubs: Stubs.statistic)
                    })
        
        view.backgroundColor = .whiteDayTracker
        view.addSubview(tableView)
        view.addSubview(stubsView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .clear

        stubsView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 396),
            
            stubsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            stubsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            stubsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            stubsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24)
        ])
        stubsView.isHidden = true
    }
    
    
    //MARK: - Navigation Bar
    
    func navigationBar(){
        if let navBar = navigationController?.navigationBar {
            navBar.topItem?.title = "Cтатистика"
            navBar.prefersLargeTitles = true
        }
    }
    
}

//MARK: - UITableViewDelegate

extension StatisticsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.StatisticCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier.cell.rawValue) as? StatisticCell else { return UITableViewCell() }
        cell.setViewModel(model: viewModel.StatisticCells[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 102
    }
    
}




//MARK: - StubView

extension StatisticsViewController {
    
    func stubViewConfig(stubs: Stubs){
        guard
            viewModel.StatisticCells.count == 0
        else { return  stubsView.isHidden = true }

        stubsView.stubViewConfig(stubs: stubs)
        stubsView.isHidden = false
    }
}
