//
//  EditTrackersViewController.swift
//  Tracker
//
//  Created by Dolnik Nikolay on 30.11.2023.
//

import UIKit

final class EditTrackersViewController: UIViewController {
    
    private var trackerService: TrackersServiseProtocol?
    private var presenter: CollectionViewPresenterProtocol?
    private var viewModel: EditViewModelProtocol
    private var categoriesViewModel: CategoriesViewModel?
    private var params = ["Категория","Расписание"]
    
    
    private var categoreName: String?
    private var name: String?
    var color: UIColor?
    var emoji: String?
    private var timetable: [Int]?
    
    
    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.frame = view.bounds
        scroll.alwaysBounceHorizontal = false
        scroll.contentSize = CGSize(width: view.frame.width, height: 1050)
        return scroll
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .whiteDayTracker
        view.frame.size =  CGSize(width: self.view.frame.width, height: 1050)
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Редактирование привычки"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .blackDayTracker
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var dayCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0 дней"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textColor = .blackDayTracker
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var nameLabel: UITextField = {
        let label = UITextField()
        label.placeholder = "Введите название трекера"
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.clearButtonMode = .whileEditing
        label.textAlignment = .left
        label.backgroundColor = .backgroundDayTracker
        //label.borderStyle = .roundedRect
        label.layer.cornerRadius = 16
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        t.register(cell.classForCoder, forCellReuseIdentifier: "cell")
        t.separatorInset = .init(top: 0, left: 20, bottom: 0, right: 20)
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
        button.setTitle("Сохранить", for: .normal)
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
    
    init(viewModel:  EditViewModelProtocol){
        self.viewModel = viewModel
       // self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTrackerParametrs()
        config()
        view.addTapGestureToHideKeyboard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setSelectedCells()
        dataCheking()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    //MARK: - UI config
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
    }
    
    func setSelectedCells(){
         guard let indexs = presenter?.setSelectedCell() else { return print("нет выделенных индексов")}
         indexs.forEach{
             presenter?.collectionView?(collectionView, didSelectItemAt: $0)
             collectionView.selectItem(at: $0, animated: true, scrollPosition: .centeredHorizontally)
         }
    }
    
    func setTrackerParametrs(){
        let model = viewModel.model
        
        dayCountLabel.text = String.localizedStringWithFormat(
            NSLocalizedString("day_Count",comment: ""),
            model.record
        )
        emoji = model.emoji
        color = model.color
        categoreName = model.categoryName
        timetable = model.timetable
        nameLabel.text = model.descriptionTracker
        
    }
    
    func config(){
        categoriesViewModel = CategoriesViewModel()
        categoriesViewModel?.$selectedCategory.bind(action: { [weak self] _ in
            self?.categoreName = self?.categoriesViewModel?.selectedCategory
            self?.tableView.reloadData()
        })
        
        
        trackerService = TrackersService.shared
        tableView.delegate = self
        tableView.dataSource = self
        
        presenter = EmojiPresenter()
        presenter?.delegate = self
        presenter?.selectedColor = color
        presenter?.selectedEmoji = emoji
        
        collectionView.delegate = presenter
        collectionView.dataSource = presenter
        collectionView.allowsMultipleSelection = true
        
        view.backgroundColor = .whiteDayTracker
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(dayCountLabel)
        contentView.addSubview(limitsLabel)
        contentView.addSubview(nameLabel)
        nameLabel.delegate = self
        nameLabel.leftView = UIView.init(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        nameLabel.leftViewMode = .always
        
        contentView.addSubview(tableView)
        contentView.addSubview(collectionView)
        contentView.addSubview(stackViewButtons)
        
        stackViewButtons.addArrangedSubview(cancelButton)
        stackViewButtons.addArrangedSubview(createButton)
        
        NSLayoutConstraint.activate([
            
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            dayCountLabel.heightAnchor.constraint(equalToConstant: 38),
            dayCountLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            dayCountLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dayCountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            
            nameLabel.heightAnchor.constraint(equalToConstant: 75),
            nameLabel.topAnchor.constraint(equalTo: dayCountLabel.bottomAnchor, constant: 40),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            limitsLabel.heightAnchor.constraint(equalToConstant: 22),
            limitsLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            limitsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            limitsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
           
            tableView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 150),
            
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

extension EditTrackersViewController: UITextFieldDelegate {
    
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

extension EditTrackersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return params.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        
        cell.backgroundColor = .backgroundDayTracker
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        cell.detailTextLabel?.textColor = .grayTracker
        cell.accessoryType = .disclosureIndicator
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = params[0]
            if categoreName != nil {
                cell.detailTextLabel?.text = categoreName
            } else {
                cell.detailTextLabel?.text = nil
            }
        case 1:
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 500)
            cell.textLabel?.text = params[1]
            if timetable != nil {
                cell.detailTextLabel?.text = WeekDay.getShortTimetable(for: timetable!)
            } else {
                cell.detailTextLabel?.text = nil
            }
        default:
            break
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
        case 1:
            tapTimeTable()
        default:
            return
        }
    }
}


extension EditTrackersViewController {
    
    func dataCheking(){
        guard let categoreName, let  name = nameLabel.text, let timetable, let color, let emoji, timetable != [],
              name.inputText()
        else {
            createButton.isEnabled = false
            createButton.backgroundColor  =  createButton.isEnabled ? .blackDayTracker : .grayTracker
            return
        }
        createButton.isEnabled = true
        createButton.backgroundColor  =  createButton.isEnabled ? .blackDayTracker : .grayTracker
    }
    
    func tapCategory(){
        categoriesViewModel?.selectedCategory = categoreName
        let vc = CategoriesViewController(viewModel: categoriesViewModel!, delegate: self)
        self.present(vc, animated: true)
    }
    
    func tapTimeTable(){
        let vc = TimeTableViewController(timetable: timetable)
        vc.delegate = self
        self.present(vc, animated: true)
    }
    
    @objc func didTapCancelButton(){
        self.dismiss(animated: true)
    }
    
    @objc func didTapCreateButton(){
        guard let categoreName, let name = nameLabel.text, let timetable, let color, let emoji, let index = viewModel.model.index else {return}
        
        trackerService?.editTracker(categoryNewName: categoreName, index: index, name: name, emoji: emoji, color: color, timetable: timetable)
        guard
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let window = windowScene.windows.first else {
            fatalError("Invalid Configuration")
        }
        let tabBarController = TabBarController()
        window.rootViewController = tabBarController
    }
}

extension EditTrackersViewController: TimeTableDelegateProtocol {
    
    func addTimetable(timetable: [Int]) {
        self.timetable = timetable
        tableView.reloadData()
        dataCheking()
    }
    
    
}

extension EditTrackersViewController: CategoriesDelegateProtocol {
    func addCategories() {
        //
    }
}

extension EditTrackersViewController: EmojiPresenterDelegateProtocol {
    
}
