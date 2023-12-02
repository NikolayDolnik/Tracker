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
    
    func showAlert(title: String?, message: String?, actionTitle: String?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .destructive))
        self.present(alert, animated: true)
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

extension Int {
     func days() -> String {
         var dayString: String!
         if "1".contains("\(self % 10)")      {dayString = "день"}
         if "234".contains("\(self % 10)")    {dayString = "дня" }
         if "567890".contains("\(self % 10)") {dayString = "дней"}
         if 11...14 ~= self % 100                   {dayString = "дней"}
    return "\(self) " + dayString
    }
}

extension String {
    func inputText() -> Bool {
        if self == "" ||
           self == " " ||
            self.trimmingCharacters(in: .whitespaces).isEmpty {
            return false
        }
        return true
    }
    
    func localized() -> String {
        NSLocalizedString(self,
                          tableName: "Localizable",
                          bundle: .main,
                          value: self,
                          comment: self)
    }
}


extension UIColor {
    
  static func == (l: UIColor, r: UIColor) -> Bool {
    var r1: CGFloat = 0
    var g1: CGFloat = 0
    var b1: CGFloat = 0
    var a1: CGFloat = 0
    l.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
    var r2: CGFloat = 0
    var g2: CGFloat = 0
    var b2: CGFloat = 0
    var a2: CGFloat = 0
    r.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
    return r1 == r2 && g1 == g2 && b1 == b2 && a1 == a2
  }
}

func == (l: UIColor?, r: UIColor?) -> Bool {
  let l = l ?? .clear
  let r = r ?? .clear
  return l == r
}
