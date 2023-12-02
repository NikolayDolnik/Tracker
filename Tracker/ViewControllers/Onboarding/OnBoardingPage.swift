//
//  OnBoardingPage.swift
//  Tracker
//
//  Created by Dolnik Nikolay on 21.11.2023.
//

import UIKit

final class PageViewController: UIViewController {
    
    private var page: Page?
    private var image = UIImageView()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Текст"
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.numberOfLines = 3
        label.textAlignment = .center
        label.textColor = .blackDayTracker
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
     init(page: Page){
         super.init(nibName: nil, bundle: nil)
        self.page = page
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        
    }
    
    func configUI(){
        
        view.addSubview(image)
        view.addSubview(titleLabel)
        
        
        image.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: view.topAnchor),
            image.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            image.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 388),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        
        guard let page else {return}
        
        titleLabel.text = page.description
        image.image = UIImage(named: page.image)
    }
    
    
}
