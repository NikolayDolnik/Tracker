//
//  HabitsViewController.swift
//  Tracker
//
//  Created by Dolnik Nikolay on 05.10.2023.
//

import Foundation
import UIKit

final class HabitsViewController: UIViewController {
    
    var trackerService: TrackersServiseProtocol?
    var presenter: CollectionViewPresenterProtocol?
    private var params = ["Категория","Расписание"]
    
   
    private var categoreName = "Cоздано контроллером"
    private var name: String?
    var color: UIColor?
    var emoji: String?
    private var timetable: [Int]?

    
    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.frame = view.bounds
        scroll.alwaysBounceHorizontal = false
        scroll.contentSize = CGSize(width: view.frame.width, height: 940)
        return scroll
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .whiteDayTracker
        view.frame.size =  CGSize(width: self.view.frame.width, height: 940)
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Новая привычка"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .blackDayTracker
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var nameLable: UITextField = {
        let lable = UITextField()
        lable.placeholder = "Введите название трекера"
        lable.clearButtonMode = .whileEditing
        lable.textAlignment = .left
        lable.layer.cornerRadius = 16 
        lable.backgroundColor = .backgroundDayTracker
        lable.borderStyle = .roundedRect
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    
    var tableView: UITableView = {
        let t = UITableView()
        t.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        t.layer.cornerRadius = 16
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
    }
    
    //MARK: - UI config
    
    func config(){
        trackerService = TrackersService.shared
        tableView.delegate = self
        tableView.dataSource = self
        
        presenter = EmojiPresenter()
        presenter?.delegate = self
        collectionView.delegate = presenter
        collectionView.dataSource = presenter
        collectionView.allowsMultipleSelection = false
        
        nameLable.delegate = self
        
        view.backgroundColor = .whiteDayTracker
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(nameLable)
        contentView.addSubview(tableView)
        contentView.addSubview(collectionView)
        contentView.addSubview(stackViewButtons)
        
        stackViewButtons.addArrangedSubview(cancelButton)
        stackViewButtons.addArrangedSubview(createButton)
        
        NSLayoutConstraint.activate([
            
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            nameLable.heightAnchor.constraint(equalToConstant: 75),
            nameLable.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            nameLable.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLable.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            nameLable.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: nameLable.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 150),
            
            collectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 32),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            collectionView.heightAnchor.constraint(equalToConstant: 440),
            
            stackViewButtons.heightAnchor.constraint(equalToConstant: 60),
            stackViewButtons.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 16),
            stackViewButtons.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackViewButtons.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
            
        ])
        
        cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        createButton.addTarget(self, action: #selector(didTapCreateButton), for: .touchUpInside)
        createButton.isEnabled = false
        createButton.backgroundColor  =  createButton.isEnabled ? .blackDayTracker : .grayTracker
        
    }
}

//MARK: - UIText Field Delegate

extension HabitsViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        name = textField.text
        dataCheking()
    }
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return textField.text != nil
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        name = textField.text
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        name = nil
        return true
    }
    
}


//MARK: - UITableViewDelegate

extension HabitsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return params.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = params[indexPath.row]
        cell.backgroundColor = .backgroundDayTracker
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            return
        case 1:
            tapTimeTable()
        default:
            return
        }
    }
}


extension HabitsViewController {
    
    func dataCheking(){
        guard let  name, let timetable   else {return}
        createButton.isEnabled = true
        createButton.backgroundColor  =  createButton.isEnabled ? .blackDayTracker : .grayTracker
    }
    
    func tapCategory(){
    }
    
    func tapTimeTable(){
        let vc = TimeTableViewController()
        vc.delegate = self
        self.present(vc, animated: true)
    }
    
    @objc func didTapCancelButton(){
        self.dismiss(animated: true)
    }
    
    @objc func didTapCreateButton(){
        guard let  name, let timetable   else {return}
        emoji = ""
        color = UIColor(named: "selection6") ?? .selection1
        trackerService?.addTracker(categoryNewName: categoreName, name: name, emoji: emoji!, color: color!, timetable: timetable)
        self.dismiss(animated: true)
    }
}

extension HabitsViewController: TimeTableDelegateProtocol {
   
    func addTimetable(timetable: [Int]) {
        self.timetable = timetable
        dataCheking()
    }
    
    
}

extension HabitsViewController: EmojiPresenterDelegateProtocol {
    
}
