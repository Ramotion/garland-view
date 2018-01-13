//
//  UIView.swift
//  GarlandCollectionDemo
//
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

extension UIView {

    /**
     Rounds the given set of corners to the specified radius

     - parameter corners: Corners to round
     - parameter radius:  Radius to round to
     */
    func round(corners: UIRectCorner, radius: CGFloat) {
        _ = _round(corners: corners, radius: radius)
    }

    /**
     Rounds the given set of corners to the specified radius with a border

     - parameter corners:     Corners to round
     - parameter radius:      Radius to round to
     - parameter borderColor: The border color
     - parameter borderWidth: The border width
     */
    func round(corners: UIRectCorner, radius: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        let mask = _round(corners: corners, radius: radius)
        addBorder(mask: mask, borderColor: borderColor, borderWidth: borderWidth)
    }

    /**
     Fully rounds an autolayout view (e.g. one with no known frame) with the given diameter and border

     - parameter diameter:    The view's diameter
     - parameter borderColor: The border color
     - parameter borderWidth: The border width
     */
    func fullyRound(diameter: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        layer.masksToBounds = true
        layer.cornerRadius = diameter / 2
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor;
    }
}

private extension UIView {

    @discardableResult func _round(corners: UIRectCorner, radius: CGFloat) -> CAShapeLayer {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        return mask
    }

    func addBorder(mask: CAShapeLayer, borderColor: UIColor, borderWidth: CGFloat) {
        let borderLayer = CAShapeLayer()
        borderLayer.path = mask.path
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.lineWidth = borderWidth
        borderLayer.frame = bounds
        layer.addSublayer(borderLayer)
    }
}

extension UIView {
    
    class func loadFromNib<T>(withName nibName: String) -> T? {
        let nib  = UINib.init(nibName: nibName, bundle: nil)
        let nibObjects = nib.instantiate(withOwner: nil, options: nil)
        for object in nibObjects {
            if let result = object as? T {
                return result
            }
        }
        return nil
    }
}
