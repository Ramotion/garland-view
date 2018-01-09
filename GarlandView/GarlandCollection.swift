//
//  GarlandCollectionViewController.swift
//  garland-view
//
//  Created by Slava Yusupov.
//  Copyright © 2017 Ramotion. All rights reserved.
//

import Foundation
import UIKit

public class GarlandCollection: UIView {
    
    public let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: GarlandLayout())
    
    fileprivate var layout: GarlandLayout {
        return collectionView.collectionViewLayout as! GarlandLayout
    }
    
    fileprivate var config: GarlandConfig {
        return GarlandConfig.shared
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = bounds
    }
}

fileprivate extension GarlandCollection {
    
    func setup() {
        frame.size.width = UIScreen.main.bounds.width
        setupCollectionView()
    }
    
    fileprivate func setupCollectionView() {
        layout.itemSize = config.cardsSize
        layout.minimumLineSpacing = config.cardsSpacing
        layout.scrollDirection = .vertical
        
        let sideInset: CGFloat = (UIScreen.main.bounds.width - config.cardsSize.width)/2
        layout.sectionInset = UIEdgeInsets(top: 0, left: sideInset, bottom: 0, right: sideInset)
        collectionView.translatesAutoresizingMaskIntoConstraints = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delaysContentTouches = true
        collectionView.clipsToBounds = true
        collectionView.collectionViewLayout.invalidateLayout()
        addSubview(collectionView)
    }
}
