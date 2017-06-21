//
//  GarlandPresentAnimationController.swift
//  GarlandView
//
//  Created by Slava Юсупов on 15.06.17.
//  Copyright © 2017 Slava Юсупов. All rights reserved.
//

import Foundation
import UIKit

class GarlandPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    var finalFromXFrame: CGFloat = 0.0
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return GarlandConfig.shared.animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? GarlandViewController,
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? GarlandViewController,
            let fromCollection = fromVC.garlandView.collectionView,
            let toCollection = toVC.garlandView.collectionView else {
                return
        }
        
        let containerView = transitionContext.containerView
        containerView.frame = fromVC.garlandView.frame
        
        fromVC.view.alpha = 0.0
        toVC.view.alpha = 0.0
        
        let fromHeaderSnapshot = fromVC.header.snapshotView(afterScreenUpdates: false)
        let headerCoord = fromCollection.convert(CGPoint(x: fromVC.header.frame.origin.x, y: fromVC.header.frame.origin.y), to: nil)
        fromHeaderSnapshot?.frame = CGRect(x: headerCoord.x, y: headerCoord.y - 40, width: fromVC.header.frame.width, height: fromVC.header.frame.height)
        containerView.addSubview(fromHeaderSnapshot!)
        
        var visibleFromSnapshots = [UIView?]()
        var convertedCellCoords = [CGPoint]()
        var cellSize = [CGSize]()
        for cell in fromCollection.visibleCells {
            let cellSnap = cell.snapshotView(afterScreenUpdates: true)
            let convertedCoord = fromCollection.convert(CGPoint(x: cell.frame.origin.x, y: cell.frame.origin.y), to: nil)
            convertedCellCoords.append(convertedCoord)
            cellSnap?.frame = CGRect(x: (convertedCoord.x), y: (convertedCoord.y - 40), width: cell.frame.width, height: cell.frame.height)
            cellSize.append(CGSize(width: cell.frame.width, height: cell.frame.height))
            visibleFromSnapshots.append(cellSnap)
            containerView.addSubview(cellSnap!)
        }
        var visibleToSnapshots = [UIView?]()
        
        for cell in fromCollection.visibleCells {
            let cellSnap = cell.snapshotView(afterScreenUpdates: true)
            let convertedCoord = fromCollection.convert(CGPoint(x: cell.frame.origin.x, y: cell.frame.origin.y), to: nil)
            cellSnap?.frame = CGRect(x: UIScreen.main.bounds.width - self.finalFromXFrame, y: convertedCoord.y, width: 0, height: 0)
            cellSnap?.alpha = 0.0
            visibleToSnapshots.append(cellSnap)
            containerView.addSubview(cellSnap!)
        }
        containerView.addSubview(toVC.view)
        
        AnimationHelper.perspectiveTransformForContainerView(containerView: containerView)
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeCubic, animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 4/5, animations: {
                
                var headerX: CGFloat = self.finalFromXFrame
                if self.finalFromXFrame == 0 {
                    headerX -= (fromHeaderSnapshot?.frame.width)!
                }
                fromHeaderSnapshot?.frame = CGRect(x: headerX, y: (fromHeaderSnapshot?.frame.origin.y)! + ((fromHeaderSnapshot?.frame.height)! - (fromHeaderSnapshot?.frame.height)!/1.6), width: (fromHeaderSnapshot?.frame.width)!/1.6, height: (fromHeaderSnapshot?.frame.height)!/1.6)
                fromHeaderSnapshot?.backgroundColor = .green
                
                for snapshot in visibleFromSnapshots {
                    snapshot?.frame = CGRect(x: self.finalFromXFrame, y: (snapshot?.frame.origin.y)!, width: 0, height: 0)
                    snapshot?.alpha = 0.0
                }
                for (index, snapshot) in visibleToSnapshots.enumerated() {
                    snapshot?.frame.origin.x = convertedCellCoords[index].x
                    snapshot?.frame.origin.y = convertedCellCoords[index].y - 40
                    snapshot?.alpha = 1.0
                    snapshot?.frame.size.width = cellSize[index].width
                    snapshot?.frame.size.height = cellSize[index].height
                }
            })
            UIView.addKeyframe(withRelativeStartTime: 4/5, relativeDuration: 1/5, animations: {
                toVC.view.alpha = 1.0
            })
        }, completion: { _ in
            for snap in visibleFromSnapshots {
                snap?.removeFromSuperview()
            }
            for snap in visibleToSnapshots {
                snap?.removeFromSuperview()
            }
            fromHeaderSnapshot?.removeFromSuperview()
            fromVC.view.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}

struct AnimationHelper {
    static func yRotation(angle: Double) -> CATransform3D {
        return CATransform3DMakeRotation(CGFloat(angle), 0.0, 1.0, 0.0)
    }
    
    static func perspectiveTransformForContainerView(containerView: UIView) {
        var transform = CATransform3DIdentity
        transform.m34 = -0.002
        containerView.layer.sublayerTransform = transform
    }
}

