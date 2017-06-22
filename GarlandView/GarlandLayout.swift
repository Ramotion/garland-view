//
//  GarlandLayout.swift
//  garland-view
//
//  Created by Slava Юсупов on 09.06.17.
//  Copyright © 2017 Ramotion Inc. All rights reserved.
//

import Foundation
import UIKit

/// :nodoc:
protocol GarlandLayoutDelegate {
    func collectionViewDidScroll()
}

class GarlandLayout: UICollectionViewFlowLayout {
    
    var delegate: GarlandLayoutDelegate?
        
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        delegate?.collectionViewDidScroll()
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
            
            let startOffset = (collectionView.contentOffset.y + GarlandConfig.shared.cardsSpacing + attributes.frame.height) / attributes.frame.height
            let maxHeight: CGFloat = 1.0
            let minHeight: CGFloat = 0.8
            
            let divided = startOffset / 3
            let height = max(minHeight, min(maxHeight, 1.0 - divided))
            header.frame.origin.y = collectionView.contentOffset.y
            header.transform = CGAffineTransform(scaleX: 1.0, y: height)
        }
        return attributes
    }
}
