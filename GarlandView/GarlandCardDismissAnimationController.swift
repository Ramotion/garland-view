//
//  GarlandCardDismissAnimationController.swift
//  GarlandView
//
//  Created by Slava Yusupov.
//  Copyright © 2017 Ramotion. All rights reserved.
//

import Foundation
import UIKit

class GarlandCardDismissAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 8 //GarlandConfig.shared.animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? GarlandCardController,
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? GarlandViewController else {
                
                transitionContext.completeTransition(false)
                return
        }
        
        let containerView = transitionContext.containerView
        containerView.insertSubview(toVC.view, at: 0)
        let cell = toVC.garlandView.collectionView.cellForItem(at: toVC.selectedCardIndex) as! GarlandCollectionCell
        let convertedCellCoord = toVC.garlandView.collectionView.convert(cell.frame.origin, to: nil)
        let convertedCellAvatarCoord = cell.convert(cell.avatar.frame.origin, to: nil)
        for subview in fromVC.card.subviews {
            subview.alpha = 0.0
        }
        
        guard let snapshot = fromVC.card.snapshotView(afterScreenUpdates: true) else {
            transitionContext.completeTransition(false)
            return
        }
        
        snapshot.frame = fromVC.card.frame
        containerView.addSubview(snapshot)
        fromVC.card.alpha = 0
        fromVC.avatar.alpha = 0
        containerView.backgroundColor = .clear
    
        
        let avatarSnapshot = UIImageView(image: fromVC.avatar.image)
        avatarSnapshot.frame = fromVC.avatar.superview?.convert(fromVC.avatar.frame, to: containerView) ?? fromVC.avatar.frame
        avatarSnapshot.clipsToBounds = true
        containerView.addSubview(avatarSnapshot)
        
        let duration = transitionDuration(using: transitionContext)
        
        //animate avatar layer properties
        let cornerRadiusAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.cornerRadius))
        cornerRadiusAnimation.fromValue = fromVC.avatar.layer.cornerRadius
        cornerRadiusAnimation.toValue = cell.avatar.layer.cornerRadius
        
        let borderWidthAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.borderWidth))
        borderWidthAnimation.fromValue = fromVC.avatar.layer.borderWidth
        borderWidthAnimation.toValue = cell.avatar.layer.borderWidth
        
        let borderColorAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.borderColor))
        borderColorAnimation.fromValue = fromVC.avatar.layer.borderColor
        borderColorAnimation.toValue = cell.avatar.layer.borderColor
        
        let animations = CAAnimationGroup()
        animations.animations = [cornerRadiusAnimation, borderWidthAnimation, borderColorAnimation]
        animations.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animations.duration = duration * 0.6
        animations.fillMode = kCAFillModeForwards
        animations.isRemovedOnCompletion = false
        avatarSnapshot.layer.add(animations, forKey: "transitionAnimations")

    
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeLinear, animations: {            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0, animations: {
                snapshot.frame = CGRect(x: convertedCellCoord.x, y: convertedCellCoord.y, width: cell.frame.width, height: cell.frame.height)
                avatarSnapshot.frame.size = cell.avatar.frame.size
                avatarSnapshot.frame.origin = convertedCellAvatarCoord
                fromVC.view.alpha = 0.0
            })
        }, completion: { _ in
            fromVC.view.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
