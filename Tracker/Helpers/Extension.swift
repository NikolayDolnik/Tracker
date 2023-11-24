//
//  Extencion.swift
//  Tracker
//
//  Created by Dolnik Nikolay on 06.10.2023.
//

import Foundation
import UIKit

extension UIViewController {
    
    func configUIButton(button: UIButton, title: String?, action: Selector?)-> UIButton {
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.backgroundColor = .blackDayTracker
        button.tintColor = .whiteDayTracker
        button.translatesAutoresizingMaskIntoConstraints = false
        guard let action = action else  {return button}
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
}

extension Array where Element: Equatable {
    func allElements(where predicate: (Element) -> Bool) -> [Element] {
        return self.compactMap{ predicate($0) ? $0 : nil }
    }
}

extension Date {
    func daysBetweenDate(toDate: Date) -> Int {
        let components = Calendar.current.dateComponents([.day], from: self, to: toDate)
        return components.day ?? 0
    }
}

extension UIView {

    func addTapGestureToHideKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        addGestureRecognizer(tapGesture)
    }

    var topSuperview: UIView? {
        var view = superview
        while view?.superview != nil {
            view = view!.superview
        }
        return view
    }

    @objc func dismissKeyboard() {
        topSuperview?.endEditing(true)
    }
}
