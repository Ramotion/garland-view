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
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.layer.masksToBounds = false
        layer.masksToBounds             = false
        
        let config = GarlandConfig.shared
        layer.cornerRadius  = config.cardRadius
        layer.shadowOffset = config.cardShadowOffset
        layer.shadowColor = config.cardShadowColor.cgColor
        layer.shadowOpacity = config.cardShadowOpacity
        layer.shadowRadius = config.cardShadowRadius
        
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}
