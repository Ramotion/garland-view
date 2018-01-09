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
    
    /// Vertical scrolling collectionView.
    public var collectionView: UICollectionView!
    
    fileprivate var containerView = UIScrollView()
    let layout = GarlandLayout()
    
    fileprivate var config: GarlandConfig {
        return GarlandConfig.shared
    }
    
    // MARK: Constructor
    /// :nodoc:
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    /// :nodoc:
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        self.frame.size.width = UIScreen.main.bounds.width
        setup()
    }
}

fileprivate extension GarlandCollection {
    
    func setup() {
        setupCollectionView()
    }
    
    fileprivate func setupCollectionView() {
        layout.itemSize = config.cardsSize
        layout.minimumLineSpacing = config.cardsSpacing
        layout.scrollDirection = .vertical
        let sideInset: CGFloat = (UIScreen.main.bounds.width - config.cardsSize.width)/2
        layout.sectionInset = UIEdgeInsets(top: 0, left: sideInset, bottom: 0, right: sideInset)
        collectionView = UICollectionView(frame: self.frame, collectionViewLayout: layout)
        containerView.insertSubview(collectionView, at: 0)
        collectionView.translatesAutoresizingMaskIntoConstraints = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delaysContentTouches = true
        collectionView.clipsToBounds = true
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

