//
//  EventsViewController.swift
//  Tracker
//
//  Created by Dolnik Nikolay on 05.10.2023.
//

import Foundation
import UIKit

final class EventViewController: UIViewController, EmojiPresenterDelegateProtocol {
    
    var trackerService: TrackersServiseProtocol?
    var presenter: CollectionViewPresenterProtocol?
    private var viewModel: CategoriesViewModel?
    private var params = ["Категория"]
    
    private var categoreName: String?
    private var name: String?
    var color: UIColor?
    var emoji: String?
    
    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.frame = view.bounds
        scroll.alwaysBounceHorizontal = false
        scroll.contentSize = CGSize(width: view.frame.width, height: 920)
        return scroll
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .whiteDayTracker
        view.frame.size =  CGSize(width: self.view.frame.width, height: 920)
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Новое нерегулярное событие"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .blackDayTracker
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var nameLabel: UITextField = {
        let lable = UITextField()
        lable.placeholder = "Введите название трекера"
        lable.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        lable.clearButtonMode = .whileEditing
        lable.textAlignment = .left
        lable.backgroundColor = .backgroundDayTracker
        //lable.borderStyle = .roundedRect
        lable.layer.cornerRadius = 16
        lable.layer.masksToBounds = true
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    
    lazy var limitsLabel: UILabel = {
        let label = UILabel()
        label.text = "Ограничение 38 символов"
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textAlignment = .center
        label.textColor = .redTracker
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    var tableView: UITableView = {
        let t = UITableView()
        t.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        t.layer.cornerRadius = 16
        t.layer.masksToBounds = true
        t.separatorStyle = .none
        t.clipsToBounds = true
        t.translatesAutoresizingMaskIntoConstraints = false
        return t
    }()
    
    var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.register(CustomCollectionViewCell.self , forCellWithReuseIdentifier: identifier.cell.rawValue)
        collection.register(SupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifier.header.rawValue)
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    let stackViewButtons: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .fill
        sv.distribution = .fillEqually
        sv.spacing = 8
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    var createButton: UIButton = {
        let button = UIButton()
        button.setTitle("Создать", for: .normal)
        button.titleLabel?.tintColor = .whiteDayTracker
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(.redTracker, for: .normal)
        button.tintColor = .redTracker
        button.backgroundColor = .whiteDayTracker
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.redTracker.cgColor
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        view.addTapGestureToHideKeyboard()
    }
    
    //MARK: - UI config
    
    func config(){
        viewModel = CategoriesViewModel()
        viewModel?.$selectedCategory.bind(action: { [weak self] _ in
            self?.categoreName = self?.viewModel?.selectedCategory
            self?.tableView.reloadData()
        })
        
        trackerService = TrackersService.shared
        tableView.delegate = self
        tableView.dataSource = self
        
        presenter = EmojiPresenter()
        presenter?.delegate = self
        collectionView.delegate = presenter
        collectionView.dataSource = presenter
        collectionView.allowsMultipleSelection = true
        
        view.backgroundColor = .whiteDayTracker
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(nameLabel)
        nameLabel.delegate = self
        nameLabel.leftView = UIView.init(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        nameLabel.leftViewMode = .always
        
        contentView.addSubview(limitsLabel)
        contentView.addSubview(tableView)
        contentView.addSubview(collectionView)
        contentView.addSubview(stackViewButtons)
        
        stackViewButtons.addArrangedSubview(cancelButton)
        stackViewButtons.addArrangedSubview(createButton)
        
        NSLayoutConstraint.activate([
            
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            nameLabel.heightAnchor.constraint(equalToConstant: 75),
            nameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
          
            limitsLabel.heightAnchor.constraint(equalToConstant: 22),
            limitsLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            limitsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            limitsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 62),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 75),
            
            collectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 32),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            collectionView.heightAnchor.constraint(equalToConstant: 460),
            
            stackViewButtons.heightAnchor.constraint(equalToConstant: 60),
            stackViewButtons.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 16),
            stackViewButtons.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackViewButtons.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
            
        ])
        limitsLabel.isHidden = true
        cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        createButton.addTarget(self, action: #selector(didTapCreateButton), for: .touchUpInside)
        createButton.isEnabled = false
        createButton.backgroundColor  =  createButton.isEnabled ? .blackDayTracker : .grayTracker
        
    }
}

//MARK: - UIText Field Delegate

extension EventViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        name = textField.text
        dataCheking()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxText = 38
        let inputText = (textField.text ?? "") as NSString
        let limitsTex = inputText.replacingCharacters(in: range, with: string)
        limitsLabel.isHidden = limitsTex.count <= maxText
        
        return limitsTex.count <= maxText
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return textField.text != nil
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        name = textField.text
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        name = nil
        limitsLabel.isHidden = true
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
}


//MARK: - UITableViewDelegate

extension EventViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return params.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = params[indexPath.row]
        cell.backgroundColor = .backgroundDayTracker
        cell.accessoryType = .disclosureIndicator
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        cell.detailTextLabel?.textColor = .grayTracker
        
        if categoreName != nil {
            cell.detailTextLabel?.text = categoreName
        } else {
            cell.detailTextLabel?.text = nil
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            tapCategory()
            return
        case 1:
            return
        default:
            return
        }
    }
}


extension EventViewController {
    
    func dataCheking(){
        guard let categoreName, let  name, let color , let emoji, name.inputText()  else {
            createButton.isEnabled = false
            createButton.backgroundColor  =  createButton.isEnabled ? .blackDayTracker : .grayTracker
            return
        }
        createButton.isEnabled = true
        createButton.backgroundColor  =  createButton.isEnabled ? .blackDayTracker : .grayTracker
    }
    
    func tapCategory(){
        let vc = CategoriesViewController(viewModel: viewModel!, delegate: self)
        self.present(vc, animated: true)
    }
    
    
    @objc func didTapCancelButton(){
        self.dismiss(animated: true)
    }
    
    @objc func didTapCreateButton(){
        guard let categoreName, let  name, let color, let emoji  else {return}
        
        trackerService?.addTrackerEvent(categoryNewName: categoreName, name: name, emoji: emoji, color: color)
        
        guard
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let window = windowScene.windows.first else {
            fatalError("Invalid Configuration")
        }
        let tabBarController = TabBarController()
        window.rootViewController = tabBarController
    }
}

extension EventViewController: CategoriesDelegateProtocol {
    func addCategories() {
        //
    }
    
}

