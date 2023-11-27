//
//  TrackersViewControllerProtocol.swift
//  Tracker
//
//  Created by Dolnik Nikolay on 19.10.2023.
//

import Foundation

public protocol TrackersViewControllerProtocol: AnyObject, TrackersCollectionViewCellDelegate {
    var trackerService: TrackersServiseProtocol?  {get set}
    var presenter: TrackersPresenterProtocol? {get set}
    func updateData(_ update: StoreUpdate)
    func update()
}
