//
//  TrackersCollectionCells.swift
//  Tracker
//
//  Created by Dolnik Nikolay on 08.10.2023.
//

import Foundation
import UIKit

public protocol TrackersCollectionViewCellDelegate: AnyObject {
    func didTapCompleteButton()
}

final class TrackersCollectionViewCell: UICollectionViewCell {
    
    var delegate: TrackersCollectionViewCellDelegate?
    private var buttonState = true
    
    var viewCard: UIView = {
       let view = UIStackView()
        view.backgroundColor  = .redTracker
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var emojiLabel: UILabel = {
        let label = UILabel()
        label.text = "😻"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let pinImage : UIImageView = {
       var view = UIImageView()
       guard let img = UIImage(named: "pin") else { return view }
        view.image = img
        view.translatesAutoresizingMaskIntoConstraints = false
       return view
    }()
    
    var descriptionLable: UILabel = {
        let label = UILabel()
        label.text = "Описание привычки"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .whiteDayTracker
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let stackViewDays: UIStackView = {
       let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .center
        sv.distribution = .equalSpacing
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    var dayCountLable: UILabel = {
        let label = UILabel()
        label.text = "0 дней"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .blackDayTracker
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var completeButton: UIButton = {
        let button = UIButton()
        let state = buttonState ? "ButtonTracker" :  "PropertyDone"
        button.setImage(UIImage(named: state), for: .normal)
        button.tintColor = .redTracker
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       config()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(){
        completeButton.addTarget(self, action: #selector(didTapCompleteButton), for: .touchUpInside)
        pinImage.isHidden = true
        
        contentView.addSubview(viewCard)
        viewCard.addSubview(emojiLabel)
        viewCard.addSubview(pinImage)
        viewCard.addSubview(descriptionLable)
        contentView.addSubview(stackViewDays)
        
  
        NSLayoutConstraint.activate([
            viewCard.topAnchor.constraint(equalTo: contentView.topAnchor),
            viewCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            viewCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            viewCard.heightAnchor.constraint(equalToConstant: 90),
            
            emojiLabel.topAnchor.constraint(equalTo: viewCard.topAnchor,constant: 12),
            emojiLabel.leadingAnchor.constraint(equalTo: viewCard.leadingAnchor, constant: 12),
            emojiLabel.heightAnchor.constraint(equalToConstant: 24),
            emojiLabel.widthAnchor.constraint(equalToConstant: 24),
            
            pinImage.topAnchor.constraint(equalTo: viewCard.topAnchor,constant: 12),
            pinImage.trailingAnchor.constraint(equalTo: viewCard.trailingAnchor, constant: -12),
            pinImage.heightAnchor.constraint(equalToConstant: 24),
            pinImage.widthAnchor.constraint(equalToConstant: 24),
            
            descriptionLable.topAnchor.constraint(greaterThanOrEqualTo: emojiLabel.bottomAnchor, constant: 8),
            descriptionLable.leadingAnchor.constraint(equalTo: viewCard.leadingAnchor, constant: 12),
            descriptionLable.trailingAnchor.constraint(equalTo: viewCard.trailingAnchor, constant: -12),
            descriptionLable.bottomAnchor.constraint(equalTo: viewCard.bottomAnchor, constant: -12)
         
        ])
        
        stackViewDays.addArrangedSubview(dayCountLable)
        stackViewDays.addArrangedSubview(completeButton)
        NSLayoutConstraint.activate([
            stackViewDays.heightAnchor.constraint(equalToConstant: 58),
            stackViewDays.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackViewDays.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 12),
            stackViewDays.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)

        ])
        
    }
    
    @objc func didTapCompleteButton(){
        print("two")
        buttonState = !buttonState
        let state = buttonState ? "ButtonTracker" : "PropertyDone"
        completeButton.setImage(UIImage(named: state), for: .normal)
        //delegate?.didTapCompleteButton()
    }
    
}
