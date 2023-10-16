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
    private var emojiCollections = ["🙂","😻","🌺","🐶","❤️","😱","😇","😡","🥶","🤔","🙌","🍔","🥦","🏓","🥇","🎸","🏝","😪"]
    
    private var colorsCollection: [UIColor] = {
        var collection = [UIColor]()
        for i in 1...18 {
            let color = UIColor(named: "selection\(i)") ?? .green
            collection.append(color)
        }
        return collection
    }()
    
}

    //MARK: - UICollectionViewDelegate UICollectionViewDataSource

extension EmojiPresenter {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? CustomCollectionViewCell else { return  }
        
        switch indexPath.section {
        case 0:
            cell.layer.cornerRadius = 16
            cell.backgroundColor = .lightGrayTracker
            delegate?.emoji = cell.titleLabel.text
        case 1:
//            cell.layer.shadowOffset = CGSizeMake(1, 1)
//            cell.layer.shadowRadius = 3
//            cell.layer.shadowOpacity = 0.23
//            cell.layer.shadowColor = cell.titleLabel.backgroundColor?.cgColor
            cell.layer.borderWidth = 1
            cell.layer.borderColor = cell.titleLabel.backgroundColor?.cgColor
            delegate?.color = cell.titleLabel.backgroundColor
            
        default:
            return
        }
        delegate?.dataCheking()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? CustomCollectionViewCell else { return  }
        delegate?.dataCheking()
        
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
            view.titleLabel.text = "Colors"
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
