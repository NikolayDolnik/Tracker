//
//  StatisticView.swift
//  Tracker
//
//  Created by Dolnik Nikolay on 27.11.2023.
//

import UIKit

final class StatisticCell: UITableViewCell {
    
   private let stackViewDays: UIStackView = {
        let sv = UIStackView()
       sv.axis = .vertical
       sv.alignment = .leading
        sv.distribution = .equalSpacing
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private var dayCountLable: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textColor = .blackDayTracker
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private var nameSatisticLable: UILabel = {
        let label = UILabel()
        label.text = "Лучший период"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .blackDayTracker
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        config()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 30, bottom: 12, right: 30))
    }
    
    func config(){
      
        contentView.addSubview(stackViewDays)
        stackViewDays.addArrangedSubview(dayCountLable)
        stackViewDays.addArrangedSubview(nameSatisticLable)
        
        NSLayoutConstraint.activate([
            stackViewDays.heightAnchor.constraint(equalToConstant: 66),
            stackViewDays.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 12),
            stackViewDays.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            stackViewDays.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 12),
            stackViewDays.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        ])
    }
    
    func setViewModel(model: StatisticCellViewModel){
        dayCountLable.text = String(model.dayCount)
        nameSatisticLable.text = model.description
        contentView.layer.cornerRadius = 16
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.redTracker.cgColor
        //contentView.layer.addSublayer(addGradientBackground())
    }
    
    func addGradientBackground() -> CAGradientLayer {
        let gradient = CAGradientLayer()
        let firstColor = UIColor.redTracker
        let secondColor = UIColor.blueTracker
        gradient.frame =  self.contentView.frame //CGRect(origin: .zero, size: self.frame.size)
        gradient.colors = [firstColor.cgColor, secondColor.cgColor]
        let shape = CAShapeLayer()
        shape.lineWidth = 2
        shape.path = UIBezierPath(rect: self.contentView.bounds).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape
//           clipsToBounds = true
//           let gradientLayer = CAGradientLayer()
//           gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor]
//           gradientLayer.frame = self.bounds
//           gradientLayer.startPoint = CGPoint(x: 0, y: 0)
//           gradientLayer.endPoint = CGPoint(x: 0, y: 1)
//           self.layer.insertSublayer(gradientLayer, at: 0)
        return gradient
       }
}
