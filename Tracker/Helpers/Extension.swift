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
