import Foundation
import UIKit

class HeaderView: UIView {
    
    @IBOutlet open var avatar: UIImageView!
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        avatar.layer.masksToBounds = true
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        avatar.layer.cornerRadius = avatar.frame.width/2
    }
}
