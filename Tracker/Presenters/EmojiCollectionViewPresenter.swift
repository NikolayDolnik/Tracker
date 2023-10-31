//
//  EmojiCollectionViewPresenter.swift
//  Tracker
//
//  Created by Dolnik Nikolay on 06.10.2023.
//

import Foundation
import UIKit

protocol CollectionViewPresenterProtocol: UICollectionViewDelegate,UICollectionViewDataSource {
    var delegate: EmojiPresenterDelegateProtocol? {get set}
}

protocol  EmojiPresenterDelegateProtocol {
    var emoji: String? {get set}
    var color: UIColor? {get set}
    func dataCheking()
}

final class EmojiPresenter: NSObject, CollectionViewPresenterProtocol {
    
    var delegate: EmojiPresenterDelegateProtocol?
    private var selectedIndex: IndexPath?
    private var emojiIndex: IndexPath?
    private var colorIndex: IndexPath?
    private var emojiCollections = ["🙂","😻","🌺","🐶","❤️","😱","😇","😡","🥶","🤔","🙌","🍔","🥦","🏓","🥇","🎸","🏝","😪"]
    
    private var colorsCollection: [UIColor] = {
        var collection = [UIColor]()
        for i in 1...18 {
            let color = UIColor(named: "selection\(i)") ?? .green
            collection.append(color)
        }
        return collection
    }()
    
    
    func deselectCell(_ collectionView: UICollectionView, for indexPath: IndexPath){
        
        guard let cell =  collectionView.cellForItem(at: indexPath) else {  return print("функция не удалила выделение") }
        
        switch indexPath.section {
        case 0:
            cell.backgroundColor = .whiteDayTracker
            delegate?.emoji = nil
            
        case 1:
            cell.layer.borderColor = UIColor.whiteDayTracker.cgColor
            delegate?.color = nil
            
        default:
            print("default")
            return
        }
    }
    
}

//MARK: - UICollectionViewDelegate UICollectionViewDataSource

extension EmojiPresenter {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        if indexPath.section == emojiIndex?.section {
//            deselectCell(collectionView, for: emojiIndex!)
//        }
//        if indexPath.section == colorIndex?.section {
//            deselectCell(collectionView, for: colorIndex!)
//        }
//
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? CustomCollectionViewCell else { return  }
        print(collectionView.indexPathsForSelectedItems)
    
        
        switch indexPath.section {
        case 0:
            cell.layer.cornerRadius = 16
            cell.backgroundColor = .lightGrayTracker
            delegate?.emoji = cell.titleLabel.text
        case 1:
            cell.layer.masksToBounds = false
            cell.layer.borderColor = nil
            
            cell.backgroundColor = .clear
            cell.layer.cornerRadius = 8
            cell.layer.borderWidth = 3
            cell.layer.borderColor = cell.titleLabel.backgroundColor?.withAlphaComponent(0.3).cgColor
            
            delegate?.color = cell.titleLabel.backgroundColor
            
        default:
            return
        }
       
        delegate?.dataCheking()
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     
        collectionView.indexPathsForSelectedItems?.filter({ $0.section == indexPath.section }).forEach({
            collectionView.deselectItem(at: $0, animated: false)
            collectionView.delegate?.collectionView?(collectionView, didDeselectItemAt: $0)
            print(collectionView.indexPathsForSelectedItems)

               })
    
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell =  collectionView.cellForItem(at: indexPath) else {  return print("функция не удалила выделение") }
        
        switch indexPath.section {
        case 0:
            cell.backgroundColor = .whiteDayTracker
            delegate?.emoji = nil
            
        case 1:
            cell.layer.borderColor = UIColor.whiteDayTracker.cgColor
            delegate?.color = nil
            
        default:
            return
        }
        print(collectionView.indexPathsForSelectedItems)
        
//        switch indexPath.section {
//        case 0:
//            self.emojiIndex = indexPath
//        case 1:
//            self.colorIndex = indexPath
//        default:
//            return
//        }
        
        delegate?.dataCheking()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return emojiCollections.count
        case 1:
            return colorsCollection.count
            
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCollectionViewCell
        switch indexPath.section {
        case 0:
            cell.titleLabel.text = emojiCollections[indexPath.row]
        case 1:
            cell.titleLabel.backgroundColor = colorsCollection[indexPath.row]
        default:
            return cell
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! SupplementaryView
        
        switch indexPath.section {
        case 0:
            view.titleLabel.text = "Emoji"
        case 1:
            view.titleLabel.text = "Цвет"
        default:
            return view
        }
        return view
    }
    
}


//MARK: - UITCollectionView FlowLayout

extension EmojiPresenter: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: 52, height: 52)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
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
        return UIEdgeInsets(top: 24, left: 2, bottom: 24, right: 2)
    }
    
}
