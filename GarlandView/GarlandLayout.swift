//
//  GarlandLayout.swift
//  garland-view
//
//  Created by Slava Юсупов on 09.06.17.
//  Copyright © 2017 Slava Юсупов. All rights reserved.
//

import Foundation
import UIKit

/// :nodoc:
protocol GarlandLayoutDelegate {
    func collectionViewDidScroll()
}

class GarlandLayout: UICollectionViewFlowLayout {
    
    var delegate: GarlandLayoutDelegate?
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        guard let collectionView = self.collectionView else {
            return proposedContentOffset
        }
        
        let pageWidth = itemSize.width + minimumLineSpacing
        
        let rawPageValue = collectionView.contentOffset.x / pageWidth
        let currentPage = velocity.x > 0 ? floor(rawPageValue) : ceil(rawPageValue)
        let nextPage = velocity.x > 0 ? ceil(rawPageValue) : floor(rawPageValue)
        let pannedLessThanPage = abs(1 + currentPage - rawPageValue) > 0.3
        let flicked = abs(velocity.x) > 0.3
        
        var offset = proposedContentOffset
        if pannedLessThanPage && flicked {
            offset.x = nextPage * pageWidth
        } else {
            offset.x = round(rawPageValue) * pageWidth
        }
        
        return offset
    }
    
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
