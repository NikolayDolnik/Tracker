//
//  FiltersViewController.swift
//  Tracker
//
//  Created by Dolnik Nikolay on 28.11.2023.
//

import UIKit

final class FiltersViewController: UIViewController {
    
    private let viewModel: FiltersViewModelProtocol
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Фильтры"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .blackDayTracker
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
   private let tableView: UITableView = {
        let t = UITableView()
        t.register(UITableViewCell.self, forCellReuseIdentifier: identifier.cell.rawValue)
        t.layer.cornerRadius = 16
        t.clipsToBounds = true
        t.isScrollEnabled = true
        t.layer.masksToBounds = true
        t.backgroundColor = .clear
        t.translatesAutoresizingMaskIntoConstraints = false
        return t
    }()
    
    init(viewModel: FiltersViewModelProtocol){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    

    func config(){
//        viewModel.filtersBind.bind(action: { [weak self] _ in
//                        guard let self else { return }
//            
//                    })
        
        tableView.delegate = self
        tableView.dataSource = self
       
        view.backgroundColor = .whiteDayTracker
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),

        ])
    }
    
}

extension FiltersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier.cell.rawValue, for: indexPath)
        cell.selectionStyle = .none
        
        if indexPath.row == viewModel.filters.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 500)
            cell.layer.cornerRadius = 16
            cell.layer.maskedCorners =  [.layerMaxXMaxYCorner,.layerMinXMaxYCorner]
        } else {
            cell.layer.cornerRadius = 0
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
        cell.textLabel?.text = viewModel.filters[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        cell.backgroundColor = .backgroundDayTracker
            
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.accessoryType = .checkmark
        viewModel.tapFilters(index: indexPath)
        self.dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.accessoryType = .none
        if indexPath.row != viewModel.filters.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.textLabel?.text == viewModel.selectedFilters{
            cell.accessoryType = .checkmark
            cell.isSelected = true
            cell.selectionStyle = .none
        } else {
            cell.accessoryType = .none
            cell.isSelected = false
        }
        
        if indexPath.row != viewModel.filters.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
    }
    
    
}

