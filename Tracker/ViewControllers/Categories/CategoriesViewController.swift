//
//  CategoriesViewController.swift
//  Tracker
//
//  Created by Dolnik Nikolay on 23.11.2023.
//

import UIKit

final class CategoriesViewController: UIViewController {
    
    private let delegate: CategoriesDelegateProtocol
    private let viewModel: CategoriesViewModelProtocol
    private let textButton = "Добавить категорию"
    private var categoryName: String?
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Категория"
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
    private var stubsView = StubView()
    private var addCategoryButton = UIButton()
    
    init(viewModel:  CategoriesViewModelProtocol, delegate: CategoriesDelegateProtocol){
        self.viewModel = viewModel
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        stubViewConfig(stubs: Stubs.category)
    }
    

    func config(){
        viewModel.categoriesBind.bind(action: { [weak self] _ in
                        guard let self else { return }
                        self.tableView.reloadData()
                        self.stubViewConfig(stubs: Stubs.date)
                    })
        
        tableView.delegate = self
        tableView.dataSource = self
        addCategoryButton = configUIButton(button: addCategoryButton, title: textButton, action: #selector(didTapAddCategoryButton))
        
        view.backgroundColor = .whiteDayTracker
        view.addSubview(stubsView)
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(addCategoryButton)
        
        stubsView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            stubsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            stubsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            stubsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            stubsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            addCategoryButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
        stubsView.isHidden = false
    }
    
}

extension CategoriesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier.cell.rawValue, for: indexPath)
        cell.selectionStyle = .none
        
        if indexPath.row == viewModel.categories.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 500)
            cell.layer.cornerRadius = 16
            cell.layer.maskedCorners =  [.layerMaxXMaxYCorner,.layerMinXMaxYCorner]
        } else {
            cell.layer.cornerRadius = 0
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
        cell.textLabel?.text = viewModel.categories[indexPath.row].categoreName
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
        
        viewModel.setSelectedcategories(selectedCategory: cell.textLabel?.text )
       // viewModel.selectedCategory = cell.textLabel?.text
        self.dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.accessoryType = .none
        if indexPath.row != viewModel.categories.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
        categoryName = nil
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.textLabel?.text == viewModel.selectedCategory {
            cell.accessoryType = .checkmark
            cell.isSelected = true
            cell.selectionStyle = .none
        } else {
            cell.accessoryType = .none
            cell.isSelected = false
        }
        
        if indexPath.row != viewModel.categories.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
        
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(actionProvider: { actions in
            return UIMenu(children: [
                UIAction(title: "Редактировать") { [weak self] _ in
                    self?.editCategory(for: indexPath)
                },
                UIAction(title: "Удалить", attributes: .destructive) { [weak self] _ in
                    self?.deleteCategory(for: indexPath)
                },
            ])
        })
    }
    
}

extension CategoriesViewController {
    
    @objc func didTapAddCategoryButton(){
        let vc = NewCategoryViewController(delegate: viewModel)
        self.present(vc, animated: true)
    }
    
    private func deleteCategory(for indexPath: IndexPath){
        if viewModel.categories[indexPath.row].categoreName == viewModel.selectedCategory {
            viewModel.setSelectedcategories(selectedCategory: nil)
        }
        viewModel.deleteCategory(for: indexPath)
    }
    
    private func editCategory(for indexPath: IndexPath){
        let oldCategoryName = viewModel.categories[indexPath.row].categoreName 
        let vc = EditCategoryViewController(oldCategoryName: oldCategoryName, delegate: viewModel)
        self.present(vc, animated: true)
    }
}


//MARK: - StubView

extension CategoriesViewController {
    
    func stubViewConfig(stubs: Stubs){
    
        guard
            viewModel.categories.count == 0
        else { return  stubsView.isHidden = true }

        stubsView.stubViewConfig(stubs: stubs)
        stubsView.isHidden = false
    }
}
