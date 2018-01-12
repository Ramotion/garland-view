import Foundation
import UIKit
import GarlandView

class HeaderView: UIView {
    
    @IBOutlet var background: UIView!
    @IBOutlet var avatar: UIImageView!
    @IBOutlet var collapsedView: UIView!
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        avatar.layer.masksToBounds = true
        
        let config = GarlandConfig.shared
        frame.size = config.headerSize
        
        layer.masksToBounds = false
        layer.cornerRadius = config.cardRadius
        layer.shadowOffset = config.cardShadowOffset
        layer.shadowColor = config.cardShadowColor.cgColor
        layer.shadowOpacity = config.cardShadowOpacity
        layer.shadowRadius = config.cardShadowRadius
        
        background.frame = bounds
        background.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        background.layer.cornerRadius = config.cardRadius
        background.layer.masksToBounds = true
        addSubview(background)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        avatar.layer.cornerRadius = avatar.frame.width/2
    }
}
