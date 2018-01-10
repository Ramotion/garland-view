//
//  GarlandCardPresentAnimationController.swift
//  GarlandView
//
//  Created by Slava Yusupov.
//  Copyright © 2017 Ramotion. All rights reserved.
//

import Foundation
import UIKit

class GarlandCardPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 8 //GarlandConfig.shared.animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? GarlandViewController,
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? GarlandCardController,
            let _ = toVC.view.snapshotView(afterScreenUpdates: true),
            let fromCell = fromVC.garlandView.collectionView.cellForItem(at: fromVC.selectedCardIndex) as? GarlandCollectionCell else {
                
                transitionContext.completeTransition(false)
                return
        }
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toVC.view)
        toVC.view.alpha = 0.0
        
        for cell in toVC.garlandCardCollection.visibleCells {
            for case let subview as UILabel in cell.contentView.subviews {
                subview.alpha = 0.0
            }
        }
        
        let snapshot = toVC.card.snapshotView(afterScreenUpdates: true)
        let convertedCellCoord = fromVC.garlandView.collectionView.convert(fromCell.frame.origin, to: nil)
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
        
        
        //base transition animations
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeLinear, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.6, animations: {
                snapshot?.frame = cardConvertedFrame
                avatarSnapshot.frame = toVC.avatar.frame
            })
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.4, animations: {
                toVC.view.alpha = 1.0
            })
        }, completion: { _ in
            avatarSnapshot.removeFromSuperview()
            snapshot?.removeFromSuperview()
            UIView.animateKeyframes(withDuration: 0.1, delay: 0, options: .calculationModeLinear, animations: {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 5/5, animations: {
                    for cell in toVC.garlandCardCollection.visibleCells {
                        for subview in cell.contentView.subviews {
                            subview.alpha = 1.0
                        }
                    }
                })
            }, completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        })
    }
}
