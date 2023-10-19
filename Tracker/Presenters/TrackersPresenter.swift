//
//  TrackersPresenter.swift
//  Tracker
//
//  Created by Dolnik Nikolay on 12.10.2023.
//

import Foundation
import UIKit

public protocol TrackersPresenterProtocol: UICollectionViewDelegate,UICollectionViewDataSource {
    var visibleCategory: [TrackerCategory] {get set}
    func newVisibleCategory(get newCategory: [TrackerCategory])
    var trackerService: TrackersServiseProtocol? {get set}
    var view: TrackersViewControllerProtocol? {get set}
    
}

final class TrackersPresenter: NSObject, TrackersPresenterProtocol {
    
    weak var view: TrackersViewControllerProtocol?
    var visibleCategory: [TrackerCategory] = []
    var trackerService: TrackersServiseProtocol?
    private var TrackersServiceObserver: NSObjectProtocol?
    
    func newVisibleCategory(get newCategory: [TrackerCategory]){
        visibleCategory = newCategory
    }

}

//MARK: - UITCollectionView DataSource & Delegate

extension TrackersPresenter: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return visibleCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visibleCategory[section].trackers.count
        }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier.cell.rawValue, for: indexPath) as! TrackersCollectionViewCell

        let tracker = visibleCategory[indexPath.section].trackers[indexPath.row]
        guard let model = trackerService?.createTrackerModel(tracker: tracker) else {return cell}
        cell.delegate  = self.view
        cell.dayCountLable.text = "\(model.record) дней"
        cell.emojiLabel.text = model.emoji
        cell.viewCard.backgroundColor = model.color
        cell.descriptionLable.text = model.descriptionTracker
        cell.completeState = model.complete
        let state = model.complete ? State.complete : State.addRecord
        cell.completeButton.setImage(UIImage(named: state.rawValue), for: .normal)
        //cell.completeButton.isEnabled = model.isEnable
        cell.completeButton.tintColor = model.color

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier.header.rawValue, for: indexPath) as! SupplementaryView
        for i in 0...indexPath.section{
            view.titleLabel.text = visibleCategory[i].categoreName
        }
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
                           
                            collectionView.performBatchUpdates{
                                collectionView.deleteItems(at: indexPaths)
                            }

                                
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
        return UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
    }
    
}

//MARK: - UITCollectionView Menu methods

extension TrackersPresenter {
    func edit(){
        
    }
    
    func pin(){
        
    }
    
    func delete(_ index: IndexPath){
       // visibleCategory.remove(at:0)
    }
}

//MARK: - TrackersCollectionViewCellDelegate

//extension TrackersPresenter: TrackersCollectionViewCellDelegate {
//
//    @objc func didTapCompleteButton(_ cell: TrackersCollectionViewCell) {
//        //let indexPath =
//
//        cell.changeState(state: cell.completeState)
//        let tracker = visibleCategory[indexPath.section].trackers[indexPath.row]
//
//        switch cell.completeState {
//        case true:
//            trackerService?.addTrackerrecord(tracker: tracker)
//            print("быа галка")
//        case false:
//            print("был плюс")
//            trackerService?.deleteTrackerRecord(tracker: tracker)
//        }
//
//        // ПЕРЕГРУЗИТЬ ЯЧЕЙКУ
//    }
//
//
//}

