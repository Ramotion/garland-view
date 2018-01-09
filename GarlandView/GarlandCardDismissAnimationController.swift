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
        return GarlandConfig.shared.animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? GarlandCardController,
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? GarlandViewController else {
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
        let snapshot = fromVC.card.snapshotView(afterScreenUpdates: true)
        snapshot?.frame = fromVC.card.frame
        containerView.addSubview(snapshot!)
        fromVC.card.alpha = 0.0
        
        
        let avatarSnapshot = fromVC.avatar.snapshotView(afterScreenUpdates: true)
        let convertedAvatarCoord = fromVC.view.convert(fromVC.avatar.frame.origin, to: nil)
        avatarSnapshot?.frame.origin = convertedAvatarCoord
        containerView.addSubview(avatarSnapshot!)
        containerView.backgroundColor = .clear
    
        
        let duration = transitionDuration(using: transitionContext)
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeLinear, animations: {            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0, animations: {
                snapshot?.frame = CGRect(x: convertedCellCoord.x, y: convertedCellCoord.y, width: cell.frame.width, height: cell.frame.height)
                avatarSnapshot?.frame.size = cell.avatar.frame.size
                avatarSnapshot?.frame.origin = convertedCellAvatarCoord
                fromVC.view.alpha = 0.0
            })
        }, completion: { _ in
            fromVC.view.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
