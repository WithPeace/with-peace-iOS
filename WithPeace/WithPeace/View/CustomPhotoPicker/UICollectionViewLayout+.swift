//
//  UICollectionViewLayout+.swift
//  WithPeace
//
//  Created by Dylan_Y on 3/18/24.
//

import UIKit

extension UICollectionViewLayout {
    
    static let defaultLayout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
        
        guard let sectionKind = LayoutSection(rawValue: sectionIndex) else { return nil }
        
        let section: NSCollectionLayoutSection
        
        if sectionKind == .defualt {
            // Item
            let leadingItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0))
            let leadingItem = NSCollectionLayoutItem(layoutSize: leadingItemSize)
            leadingItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            // Group
            let leadingGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(0.5))
            let leadingGroup = NSCollectionLayoutGroup.horizontal(layoutSize: leadingGroupSize, subitems: [leadingItem])

            let containerGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                            heightDimension: .fractionalWidth(0.5))
            let containerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: containerGroupSize,
                                                                    subitems: [leadingGroup])
            
            section = NSCollectionLayoutSection(group: containerGroup)
            section.interGroupSpacing = 2
            section.orthogonalScrollingBehavior = .none
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        } else {
            fatalError("Layout ERROR")
        }
        return section
    }
}

enum LayoutSection: Int, Hashable, CaseIterable, CustomStringConvertible {
    case defualt = 0
    case three
    
    var description: String {
        switch self {
        case .defualt:
            return "default"
        case .three:
            return "three"
        }
    }
}
