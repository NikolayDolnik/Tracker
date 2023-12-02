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
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0))
        contentView.layer.cornerRadius = 16
        contentView.layer.addSublayer((addGradientBackground()))
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
    }
    
    func addGradientBackground() -> CAGradientLayer {
        let gradient = CAGradientLayer()
        let firstColor = UIColor.red
        let secondColor = UIColor.green
        let thirdColor = UIColor.blue
        
        gradient.frame = CGRect(origin: .zero, size: contentView.frame.size)
        gradient.colors = [firstColor.cgColor, secondColor.cgColor, thirdColor.cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        let shape = CAShapeLayer()
        shape.lineWidth = 1
        shape.path = UIBezierPath(roundedRect: contentView.frame, cornerRadius: 16).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape
        
        return gradient
    }
  
}
