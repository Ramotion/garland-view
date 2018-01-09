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
        return GarlandConfig.shared.animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? GarlandViewController,
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? GarlandCardController,
            let _ = toVC.view.snapshotView(afterScreenUpdates: true),
            let fromCell = fromVC.garlandView.collectionView.cellForItem(at: fromVC.selectedCardIndex) as? GarlandCollectionCell else {
                return
        }
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toVC.view)
        toVC.view.alpha = 0.0
        
        for cell in toVC.garlandCardCollection.visibleCells {
            for subview in cell.contentView.subviews {
                if subview is UILabel {
                    subview.alpha = 0.0
                }
            }
        }
        
        let snapshot = toVC.card.snapshotView(afterScreenUpdates: true)
        let convertedCellCoord = fromVC.garlandView.collectionView.convert(fromCell.frame.origin, to: nil)
        let cardConvertedFrame = toVC.view.convert(toVC.card.frame, to: nil)
        snapshot?.frame = CGRect(x: convertedCellCoord.x, y: convertedCellCoord.y, width: GarlandConfig.shared.cardsSize.width, height: GarlandConfig.shared.cardsSize.height)
        containerView.addSubview(snapshot!)
        

        let avatarSnapshot = fromCell.avatar.snapshotView(afterScreenUpdates: true)
        let convertedAvatarCoord = fromCell.convert(fromCell.avatar.frame.origin, to: nil)
        avatarSnapshot?.frame.origin = convertedAvatarCoord
        containerView.addSubview(avatarSnapshot!)
        
        
        let duration = transitionDuration(using: transitionContext)
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeLinear, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 3/5, animations: {
                snapshot?.frame = cardConvertedFrame
                avatarSnapshot?.frame = toVC.avatar.frame
            })
            UIView.addKeyframe(withRelativeStartTime: 3/5, relativeDuration: 2/5, animations: {
                toVC.view.alpha = 1.0
            })
        }, completion: { _ in
            avatarSnapshot?.removeFromSuperview()
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
