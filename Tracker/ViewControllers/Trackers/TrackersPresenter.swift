//
//  TrackersPresenter.swift
//  Tracker
//
//  Created by Dolnik Nikolay on 12.10.2023.
//

import Foundation
import UIKit

public protocol TrackersPresenterProtocol: UICollectionViewDelegate,UICollectionViewDataSource {
    var trackerService: TrackersServiseProtocol? {get set}
    var view: TrackersViewControllerProtocol? {get set}
    
}

final class TrackersPresenter: NSObject, TrackersPresenterProtocol {
    
    weak var view: TrackersViewControllerProtocol?
    var trackerService: TrackersServiseProtocol?
    private var TrackersServiceObserver: NSObjectProtocol?
    private var dayCountlabel = NSLocalizedString("dayCountlabel", comment: "")
    
}

//MARK: - UITCollectionView DataSource & Delegate

extension TrackersPresenter: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let number = trackerService?.numberOfSections else {
            return 0 }
        return number
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trackerService?.numberOfRowsInSection(section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier.cell.rawValue, for: indexPath) as! TrackersCollectionViewCell
        
        guard let model = trackerService?.objectModel(at: indexPath) else {return cell}
        
        cell.delegate  = self.view
        
        cell.dayCountLable.text = String.localizedStringWithFormat(
            NSLocalizedString("day_Count",comment: ""),
            model.record
        )

       // cell.dayCountLable.text = model.record.days()
        cell.emojiLabel.text = model.emoji
        cell.viewCard.backgroundColor = model.color
        cell.descriptionLable.text = model.descriptionTracker
        cell.completeState = model.complete
        let state = model.complete ? State.complete : State.addRecord
        cell.completeButton.setImage(UIImage(named: state.rawValue), for: .normal)
        cell.completeButton.isEnabled = model.isEnable
        cell.completeButton.tintColor = model.color
        cell.completeButton.setTitleColor(model.color, for: .disabled)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier.header.rawValue, for: indexPath) as! SupplementaryView
        
        guard let name = trackerService?.nameforSection(indexPath.section) else { return view }
        view.titleLabel.text = name
        
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard indexPaths.count > 0 else {
            return nil
        }
        
        return UIContextMenuConfiguration(actionProvider: { actions in
            return UIMenu(children: [
                UIAction(title: "Закрепить") { [weak self] _ in
                    self?.pin()
                },
                UIAction(title: "Редактировать") { [weak self] _ in
                    self?.edit()
                },
                UIAction(title: "Удалить", attributes: .destructive) { [weak self] _ in
                    self?.delete(indexPaths[0])
                },
            ])
        })
    }
    
}


//MARK: - UITCollectionView FlowLayout

extension TrackersPresenter: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: 167, height: 148)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width,
                                                         height: UIView.layoutFittingExpandedSize.height),
                                                  withHorizontalFittingPriority: .required,
                                                  verticalFittingPriority: .fittingSizeLevel)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 0, bottom: 16, right: 0)
    }
    
    
}

//MARK: - UITCollectionView Menu methods

extension TrackersPresenter {
    func edit(){
        
    }
    
    func pin(){
        
    }
    
    func delete(_ index: IndexPath){
        trackerService?.deleteTracker(for: index)
    }
}

