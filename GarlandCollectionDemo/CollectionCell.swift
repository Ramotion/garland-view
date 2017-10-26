//
//  CollectionCell.swift
//  GarlandView
//
//  Created by Slava Yusupov.
//  Copyright © 2017 Ramotion. All rights reserved.
//

import Foundation
import UIKit
import GarlandView

class CollectionCell: GarlandCollectionCell {
    
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        commonInit()
    }
    
    fileprivate func commonInit() {
        configurateCell()
    }
    
    fileprivate func configurateCell() {
        self.layer.masksToBounds = true
        
        
        contentView.layer.masksToBounds = false
        layer.masksToBounds             = false
        
        let config = GarlandConfig.shared
        self.layer.cornerRadius  = config.cardRadius
        self.layer.shadowOffset = config.cardShadowOffset
        self.layer.shadowColor = config.cardShadowColor.cgColor
        self.layer.shadowOpacity = config.cardShadowOpacity
        self.layer.shadowRadius = config.cardShadowRadius
        
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}
