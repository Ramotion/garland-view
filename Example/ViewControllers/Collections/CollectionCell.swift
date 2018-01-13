//
//  CollectionCell.swift
//  GarlandView
//
//  Copyright © 2017 Ramotion. All rights reserved.
//

import Foundation
import UIKit
import GarlandView

class CollectionCell: UICollectionViewCell {
    
    @IBOutlet open var avatar: UIImageView!
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        avatar.layer.masksToBounds = true
        contentView.layer.masksToBounds = false
        layer.masksToBounds = false
        
        let config = GarlandConfig.shared
        layer.cornerRadius  = config.cardRadius
        layer.shadowOffset = config.cardShadowOffset
        layer.shadowColor = config.cardShadowColor.cgColor
        layer.shadowOpacity = config.cardShadowOpacity
        layer.shadowRadius = config.cardShadowRadius
        
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        avatar.layer.cornerRadius = avatar.frame.width/2
    }
}
