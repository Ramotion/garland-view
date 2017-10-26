//
//  UIView.swift
//  GarlandCollectionDemo
//
//  Created by Slava Yusupov.
//  Copyright © 2017 Ramotion. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func findConstraints(attribute: NSLayoutAttribute) -> [NSLayoutConstraint] {
        let result = self.constraints.filter { $0.firstAttribute == attribute && $0.firstItem as? NSObject == self }
        return result
    }
    
    func findSuperviewConstraints(attribute: NSLayoutAttribute) -> [NSLayoutConstraint] {
        let result = superview?.constraints.filter { $0.firstAttribute == attribute && $0.firstItem as? NSObject == self }
        return result ?? []
    }
    
    func fromNib<T : UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}
