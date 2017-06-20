//
//  GarlandCollectionViewController.swift
//  garland-view
//
//  Created by Slava Юсупов on 08.06.17.
//  Copyright © 2017 Slava Юсупов. All rights reserved.
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
        let insets = config.sideInsets
        let rightInset = UIScreen.main.bounds.width - config.cardsSize.width - insets.left
        layout.sectionInset = UIEdgeInsets(top: 0, left: insets.left, bottom: 0, right: rightInset)
        layout.delegate = self
        
        collectionView = UICollectionView(frame: self.frame, collectionViewLayout: layout)
        containerView.insertSubview(collectionView, at: 0)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delaysContentTouches = true
        collectionView.clipsToBounds = false
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

extension GarlandCollection: UIScrollViewDelegate {
    
}

extension GarlandCollection: GarlandLayoutDelegate {
    
    func collectionViewDidScroll() {
        for cell in self.collectionView.visibleCells {
            print("cell")
        }
    }
}

