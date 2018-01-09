//
//  GarlandPresentAnimationController.swift
//  GarlandView
//
//  Created by Slava Yusupov.
//  Copyright © 2017 Ramotion. All rights reserved.
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
              let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? GarlandViewController else {
                
                transitionContext.completeTransition(false)
                return
        }
    
        let fromCollection = fromVC.garlandView.collectionView
        let toCollection = toVC.garlandView.collectionView
        
        let containerView = transitionContext.containerView
        
        containerView.frame = fromVC.view.frame
        containerView.addSubview(toVC.view)
        toVC.view.frame = UIScreen.main.bounds
        toVC.view.layoutSubviews()
        
        var visibleFromSnapshots = [UIView?]()
        var convertedFromCellCoords = [CGPoint]()
        var cellSize = [CGSize]()
        for cell in fromCollection.visibleCells {
            guard let cellSnap = cell.snapshotView(afterScreenUpdates: true) else { break }
            let convertedCoord = fromCollection.convert(CGPoint(x: cell.frame.origin.x, y: cell.frame.origin.y), to: nil)
            cellSnap.frame = CGRect(x: (convertedCoord.x), y: (convertedCoord.y), width: cell.frame.width, height: cell.frame.height)
            cellSize.append(CGSize(width: cell.frame.width, height: cell.frame.height))
            cellSnap.alpha = 1.0
            let config = GarlandConfig.shared
            cellSnap.layer.cornerRadius  = config.cardRadius
            cellSnap.layer.shadowOffset = config.cardShadowOffset
            cellSnap.layer.shadowColor = config.cardShadowColor.cgColor
            cellSnap.layer.shadowOpacity = config.cardShadowOpacity
            cellSnap.layer.shadowRadius = config.cardShadowRadius
            visibleFromSnapshots.append(cellSnap)
            containerView.addSubview(cellSnap)
        }
        
        var visibleToSnapshots = [UIView?]()
        for cell in toCollection.visibleCells {
            guard let cellSnap = cell.snapshotView(afterScreenUpdates: true) else { break }
            let convertedCoord = toCollection.convert(CGPoint(x: cell.frame.origin.x, y: cell.frame.origin.y), to: nil)
            convertedFromCellCoords.append(convertedCoord)
            cellSnap.frame.size = CGSize(width: cellSnap.frame.width/3, height: cellSnap.frame.height/2)
            var finalX = self.finalFromXFrame
            if finalX == UIScreen.main.bounds.width {
                finalX += cellSnap.frame.width
            }
            cellSnap.frame.origin = CGPoint(x: UIScreen.main.bounds.width - finalX, y: convertedCoord.y + cellSnap.frame.height/2)
            cellSnap.alpha = 0.2
            let config = GarlandConfig.shared
            cellSnap.layer.cornerRadius = config.cardRadius
            cellSnap.layer.shadowOffset = config.cardShadowOffset
            cellSnap.layer.shadowColor = config.cardShadowColor.cgColor
            cellSnap.layer.shadowOpacity = config.cardShadowOpacity
            cellSnap.layer.shadowRadius = config.cardShadowRadius
            visibleToSnapshots.append(cellSnap)
            containerView.addSubview(cellSnap)
        }
        
        let fromHeaderSnapshot = fromVC.headerView.snapshotView(afterScreenUpdates: true)
        let fromHeaderCoord = fromCollection.convert(CGPoint(x: fromVC.headerView.frame.origin.x, y: fromVC.headerView.frame.origin.y), to: nil)
        fromHeaderSnapshot?.frame = CGRect(x: fromHeaderCoord.x, y: fromHeaderCoord.y, width: fromVC.headerView.frame.width, height: fromVC.headerView.frame.height)
        containerView.addSubview(fromHeaderSnapshot!)
        
        var headerFromX: CGFloat = fromVC.rightFakeHeader.frame.origin.x
        var headerToX: CGFloat = toVC.leftFakeHeader.frame.origin.x
        if self.finalFromXFrame == 0 {
            headerFromX = fromVC.leftFakeHeader.frame.origin.x
            headerToX = toVC.rightFakeHeader.frame.origin.x
        }
        
        let toHeaderSnapshot = fromVC.headerView.snapshotView(afterScreenUpdates: true)
        let toHeaderCoord = fromCollection.convert(CGPoint(x: fromVC.headerView.frame.origin.x, y: fromVC.headerView.frame.origin.y), to: nil)
        toHeaderSnapshot?.frame = CGRect(x: headerToX, y: toHeaderCoord.y + ((toHeaderSnapshot?.frame.height)! - (toHeaderSnapshot?.frame.height)!/1.6)/2, width: toVC.headerView.frame.width/1.6, height: toVC.headerView.frame.height/1.6)
        containerView.addSubview(toHeaderSnapshot!)
        
        fromVC.garlandView.collectionView.alpha = 0.0
        toVC.garlandView.collectionView.alpha = 0.0
        
        AnimationHelper.perspectiveTransformForContainerView(containerView: containerView)
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeLinear, animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 4/5, animations: {
                
                fromHeaderSnapshot?.frame = CGRect(x: headerFromX, y: (fromHeaderSnapshot?.frame.origin.y)! + ((fromHeaderSnapshot?.frame.height)! - (fromHeaderSnapshot?.frame.height)!/1.6)/2, width: (fromHeaderSnapshot?.frame.width)!/1.6, height: (fromHeaderSnapshot?.frame.height)!/1.6)
                fromHeaderSnapshot?.alpha = 0.2
                
                toHeaderSnapshot?.frame = CGRect(x: toHeaderCoord.x, y: toHeaderCoord.y, width: toVC.headerView.frame.width, height: toVC.headerView.frame.height)
                
                for (index, snapshot) in visibleToSnapshots.enumerated() {
                    snapshot?.frame.origin.x = convertedFromCellCoords[index].x
                    snapshot?.frame.origin.y = convertedFromCellCoords[index].y
                    snapshot?.alpha = 1.0
                    snapshot?.frame.size.width = cellSize[index].width
                    snapshot?.frame.size.height = cellSize[index].height
                }
                for snapshot in visibleFromSnapshots {
                    if let nonNilSnap = snapshot {
                        nonNilSnap.frame.size = CGSize(width: nonNilSnap.frame.width/3, height: nonNilSnap.frame.height/2)
                        var finalX = self.finalFromXFrame
                        if finalX == 0 {
                            finalX -= nonNilSnap.frame.width
                        }
                        nonNilSnap.frame.origin = CGPoint(x: finalX, y: nonNilSnap.frame.origin.y + nonNilSnap.frame.height/2)
                        nonNilSnap.alpha = 0.0
                    }
                }
            })
            UIView.addKeyframe(withRelativeStartTime: 4/5, relativeDuration: 1/5, animations: {
                toVC.garlandView.collectionView.alpha = 1.0
            })
        }, completion: { _ in
            for snap in visibleFromSnapshots {
                snap?.removeFromSuperview()
            }
            for snap in visibleToSnapshots {
                snap?.removeFromSuperview()
            }
            fromHeaderSnapshot?.removeFromSuperview()
            toHeaderSnapshot?.removeFromSuperview()
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

