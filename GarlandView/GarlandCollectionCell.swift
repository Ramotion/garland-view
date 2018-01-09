//
//  GarlandCollectionCell.swift
//  GarlandView
//
//  Created by Slava Yusupov.
//  Copyright © 2017 Ramotion. All rights reserved.
//

import Foundation
import UIKit

open class GarlandCollectionCell: UICollectionViewCell {
    
    @IBOutlet open var avatar: UIImageView!
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        avatar.layer.cornerRadius = avatar.frame.width/2
    }
}
