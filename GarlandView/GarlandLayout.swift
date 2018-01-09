//
//  GarlandLayout.swift
//  garland-view
//
//  Created by Slava Yusupov.
//  Copyright © 2017 Ramotion. All rights reserved.
//

import Foundation
import UIKit

class GarlandLayout: UICollectionViewFlowLayout {
        
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }
        let transformed = attributes.map { transformLayoutAttributes($0) }
        return transformed
    }
    
    private func transformLayoutAttributes(_ attributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
        guard let collectionView = self.collectionView else { return attributes }
        
        if let header = collectionView.viewWithTag(99) {
            header.frame.origin.y = collectionView.contentOffset.y
        }
        return attributes
    }
}
