//
//  GarlandCollectionViewController.swift
//  garland-view
//
//  Copyright © 2017 Ramotion. All rights reserved.
//

import Foundation
import UIKit

public class GarlandCollection: UICollectionView {
    
    public init() {
        let config = GarlandConfig.shared
        let sideInset: CGFloat = (UIScreen.main.bounds.width - config.cardsSize.width)/2
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: sideInset, bottom: 0, right: sideInset)
        layout.itemSize = config.cardsSize
        layout.minimumLineSpacing = config.cardsSpacing
        layout.scrollDirection = .vertical
        
        super.init(frame: CGRect.zero, collectionViewLayout: layout)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        delaysContentTouches = true
        clipsToBounds = true
        backgroundColor = .clear
    }
}
