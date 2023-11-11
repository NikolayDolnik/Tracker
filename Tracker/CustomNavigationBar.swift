//
//  CustomNavigationController.swift
//  Tracker
//
//  Created by Dolnik Nikolay on 03.10.2023.
//

import Foundation
import UIKit

final class CustomNavigationBar: UINavigationBar {
    
    var createButton = UIBarButtonItem(image: UIImage(named: "addTracker"), style: .done, target: .none, action: nil)
  
   
    func creacte(){
//        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44))
//        view.addSubview(navBar)

        let navItem = UINavigationItem(title: "SomeTitle")
        let doneItem = createButton
        navItem.leftBarButtonItem = doneItem

       self.setItems([navItem], animated: false)
    }
   
    
}
