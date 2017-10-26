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
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        commonInit()
    }
    
    fileprivate func commonInit() {
        setup()
    }
    
    fileprivate func setup() {
        avatar.layer.cornerRadius = avatar.frame.width/2
    }
}
