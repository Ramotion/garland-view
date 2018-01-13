//
//  GarlandCardPresentAnimationController.swift
//  GarlandView
//
//  Copyright © 2017 Ramotion. All rights reserved.
//

import Foundation
import UIKit
import GarlandView

class UserCardPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return GarlandConfig.shared.animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? GarlandViewController,
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? UserCardViewController,
            let _ = toVC.view.snapshotView(afterScreenUpdates: true),
            let fromCell = fromVC.garlandCollection.cellForItem(at: fromVC.selectedCardIndex) as? CollectionCell else {
                
                transitionContext.completeTransition(false)
                return
        }
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toVC.view)
        toVC.view.alpha = 0.0
        toVC.garlandCardCollection.alpha = 0
        toVC.avatar.alpha = 0
        
        let snapshot = toVC.card.snapshotView(afterScreenUpdates: true)
        let convertedCellCoord = fromVC.garlandCollection.convert(fromCell.frame.origin, to: nil)
        let cardConvertedFrame = toVC.view.convert(toVC.card.frame, to: nil)
        snapshot?.frame = CGRect(x: convertedCellCoord.x, y: convertedCellCoord.y, width: GarlandConfig.shared.cardsSize.width, height: GarlandConfig.shared.cardsSize.height)
        containerView.addSubview(snapshot!)
        
        let avatarSnapshot = UIImageView(image: fromCell.avatar.image)
        avatarSnapshot.frame = fromCell.convert(fromCell.avatar.frame, to: containerView)
        avatarSnapshot.clipsToBounds = true
        containerView.addSubview(avatarSnapshot)
        
        let duration = transitionDuration(using: transitionContext)
        
        //animate avatar layer properties
        let cornerRadiusAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.cornerRadius))
        cornerRadiusAnimation.fromValue = fromCell.avatar.layer.cornerRadius
        cornerRadiusAnimation.toValue = toVC.avatar.layer.cornerRadius
        
        let borderWidthAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.borderWidth))
        borderWidthAnimation.fromValue = fromCell.avatar.layer.borderWidth
        borderWidthAnimation.toValue = toVC.avatar.layer.borderWidth
        
        let borderColorAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.borderColor))
        borderColorAnimation.fromValue = fromCell.avatar.layer.borderColor
        borderColorAnimation.toValue = toVC.avatar.layer.borderColor
        
        let animations = CAAnimationGroup()
        animations.animations = [cornerRadiusAnimation, borderWidthAnimation, borderColorAnimation]
        animations.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        animations.duration = duration * 0.6
        animations.fillMode = kCAFillModeForwards
        animations.isRemovedOnCompletion = false
        avatarSnapshot.layer.add(animations, forKey: "transitionAnimations")
        
        toVC.card.alpha = 0
        
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeLinear, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0, animations: {
                snapshot?.frame = cardConvertedFrame
                avatarSnapshot.frame = toVC.avatar.frame
            })
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.7, animations: {
                toVC.view.alpha = 1.0
            })
        }, completion: { _ in
            avatarSnapshot.removeFromSuperview()
            snapshot?.removeFromSuperview()
            toVC.avatar.alpha = 1
            toVC.card.alpha = 1
            
            UIView.animate(withDuration: 0.5, animations: {
                toVC.garlandCardCollection.alpha = 1.0
            }, completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        })
    }
}
