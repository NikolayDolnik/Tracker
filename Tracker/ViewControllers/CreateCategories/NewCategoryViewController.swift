//
//  CreateCategoriesViewController.swift
//  Tracker
//
//  Created by Dolnik Nikolay on 23.11.2023.
//

import UIKit

protocol NewCategoryDelegateProtocol {
    func addTrackerCategory(categoryName: String)
}

final class NewCategoryViewController: UIViewController {
    
    private var categoryName: String?
    var delegate: NewCategoryDelegateProtocol?
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Новая категория"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .blackDayTracker
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
   private var nameLable: UITextField = {
        let lable = UITextField()
        lable.placeholder = "Введите название категории"
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
    private var completeButton = UIButton()
    private var buttonText = "Готово"
    
    init(delegate: NewCategoryDelegateProtocol){
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        view.addTapGestureToHideKeyboard()
    }
    
    //MARK: - UI config
    
    func config(){
        
        view.backgroundColor = .whiteDayTracker
        view.addSubview(titleLabel)
        view.addSubview(completeButton)
        view.addSubview(nameLable)
        completeButton = configUIButton(button: completeButton, title: buttonText, action: #selector(didTapCompleteButton))
        nameLable.delegate = self
        nameLable.leftView = UIView.init(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        nameLable.leftViewMode = .always
      
   
        NSLayoutConstraint.activate([
            
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            nameLable.heightAnchor.constraint(equalToConstant: 75),
            nameLable.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            nameLable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameLable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            completeButton.heightAnchor.constraint(equalToConstant: 60),
            completeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            completeButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            completeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
            
        ])
    }
}

//MARK: - UIText Field Delegate

extension NewCategoryViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        categoryName = textField.text
        dataCheking()
    }
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return textField.text != nil
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        categoryName = textField.text
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        categoryName = nil
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
}

extension NewCategoryViewController {
    
    func dataCheking(){
        guard let  categoryName, categoryName != "", categoryName != " "  else {
            completeButton.isEnabled = false
            completeButton.backgroundColor  =  completeButton.isEnabled ? .blackDayTracker : .grayTracker
            return
        }
        completeButton.isEnabled = true
        completeButton.backgroundColor  =  completeButton.isEnabled ? .blackDayTracker : .grayTracker
    }
    
    @objc func didTapCompleteButton(){
        guard let  categoryName  else { return }
        try? delegate?.addTrackerCategory(categoryName: categoryName)
        self.dismiss(animated: true)
    }
}



