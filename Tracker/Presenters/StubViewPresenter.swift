//
//  StubViewPresenter.swift
//  Tracker
//
//  Created by Dolnik Nikolay on 10.11.2023.
//

import UIKit

final class StubView: UIView {
    
    let image = UIImageView(image: UIImage(named: Stubs.date.image))
    let label: UILabel = {
        let label = UILabel()
        label.text = Stubs.date.description
        label.font = .systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 345, height: 150))
        
        addSubview(image)
        addSubview(label)

        image.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
       
        NSLayoutConstraint.activate([
            image.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            image.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            label.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 8)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func stubViewConfig(stubs: Stubs){
        image.image = UIImage(named: stubs.image)
        label.text = stubs.description
    }
    
}
