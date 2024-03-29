//
//  StoreDelegateProtocol.swift
//  Tracker
//
//  Created by Dolnik Nikolay on 08.11.2023.
//

import Foundation

protocol StoreDelegateProtocol: AnyObject {
    func didUpdate(_ update: StoreUpdate)
    
}
