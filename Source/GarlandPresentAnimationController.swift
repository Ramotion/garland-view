//
//  GarlandAnimationController.swift
//  GarlandView
//
//  Copyright © 2017 Ramotion. All rights reserved.
//

import Foundation
import UIKit

public class GarlandAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    public enum TransitionDirection {
        case left
        case right
    }
    
    var transitionDirection: TransitionDirection = .right
    private var finalFromXFrame: CGFloat {
        return transitionDirection == .right ? UIScreen.main.bounds.width : 0
    }
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return GarlandConfig.shared.animationDuration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? GarlandViewController,
              let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? GarlandViewController,
              let fromHeaderSnapshot = fromVC.headerView.snapshotView(afterScreenUpdates: true) else {
                
                transitionContext.completeTransition(false)
                return
        }
    
        let fromCollection = fromVC.garlandCollection
        let toCollection = toVC.garlandCollection
        
        let containerView = transitionContext.containerView
        
        containerView.frame = fromVC.view.frame
        containerView.addSubview(toVC.view)
        toVC.view.frame = UIScreen.main.bounds
        toVC.view.layoutSubviews()
        
        guard let toHeaderSnapshot = toVC.headerView.snapshotView(afterScreenUpdates: true),
            let rightFakeHeaderSnapshot = toVC.rightFakeHeader.snapshotView(afterScreenUpdates: true),
            let leftFakeHeaderSnapshot = toVC.leftFakeHeader.snapshotView(afterScreenUpdates: true) else {
            
            transitionContext.completeTransition(false)
            return
        }
        
        
        let headerStartFrame = fromVC.view.convert(fromVC.headerView.frame, to: containerView)
        let headerFinalFrame = CGRect(origin: headerStartFrame.origin, size: toHeaderSnapshot.frame.size)
        
        //generate & configure cells transition views
        var visibleFromSnapshots: [UIView] = []
        var overlappedCells: [UIView] = []
        var convertedFromCellCoords: [CGPoint] = []
        var cellSize: [CGSize] = []
        for cell in fromCollection.visibleCells {
            guard let cellSnap = cell.snapshotView(afterScreenUpdates: true) else { continue }
            let convertedCoord = fromCollection.convert(CGPoint(x: cell.frame.origin.x, y: cell.frame.origin.y), to: nil)
            cellSnap.frame = CGRect(x: (convertedCoord.x), y: (convertedCoord.y), width: cell.frame.width, height: cell.frame.height)
            cellSize.append(CGSize(width: cell.frame.width, height: cell.frame.height))
            if convertedCoord.y < headerStartFrame.minY {
                cellSnap.alpha = 0
            } else if convertedCoord.y < headerStartFrame.maxY {
                overlappedCells.append(cellSnap)
            }
            let config = GarlandConfig.shared
            cellSnap.layer.cornerRadius  = config.cardRadius
            cellSnap.layer.shadowOffset = config.cardShadowOffset
            cellSnap.layer.shadowColor = config.cardShadowColor.cgColor
            cellSnap.layer.shadowOpacity = config.cardShadowOpacity
            cellSnap.layer.shadowRadius = config.cardShadowRadius
            visibleFromSnapshots.append(cellSnap)
            containerView.addSubview(cellSnap)
        }
        
        var visibleToSnapshots: [UIView] = []
        for cell in toCollection.visibleCells {
            guard let cellSnap = cell.snapshotView(afterScreenUpdates: true) else { continue }
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
        
        //configure headers
        fromHeaderSnapshot.frame = headerStartFrame
        let config = GarlandConfig.shared
        fromHeaderSnapshot.layer.masksToBounds = false
        fromHeaderSnapshot.layer.cornerRadius = config.cardRadius
        fromHeaderSnapshot.layer.shadowOffset = config.cardShadowOffset
        fromHeaderSnapshot.layer.shadowColor = config.cardShadowColor.cgColor
        fromHeaderSnapshot.layer.shadowOpacity = config.cardShadowOpacity
        fromHeaderSnapshot.layer.shadowRadius = config.cardShadowRadius
        
        let toFakeHeader = finalFromXFrame == 0 ? toVC.rightFakeHeader : toVC.leftFakeHeader
        let fromFakeHeader = finalFromXFrame == 0 ? toVC.leftFakeHeader : toVC.rightFakeHeader
        let toFakeHeaderSnapshot = finalFromXFrame == 0 ? rightFakeHeaderSnapshot : leftFakeHeaderSnapshot
        let fromFakeHeaderSnapshot = finalFromXFrame == 0 ? leftFakeHeaderSnapshot : rightFakeHeaderSnapshot
        
        let headerToFrame: CGRect = toVC.view.convert(toFakeHeader.frame, to: containerView)
        let headerFromFrame: CGRect = toVC.view.convert(fromFakeHeader.frame, to: containerView)
        
        toFakeHeaderSnapshot.frame = headerToFrame
        fromFakeHeaderSnapshot.frame = headerStartFrame
        toHeaderSnapshot.frame = headerToFrame
        toHeaderSnapshot.alpha = 0
        
        containerView.addSubview(toFakeHeaderSnapshot)
        containerView.addSubview(fromFakeHeaderSnapshot)
        containerView.addSubview(toHeaderSnapshot)
        containerView.addSubview(fromHeaderSnapshot)
        
        //hide origin views
        //fromFakeHeaderSnapshot.alpha = 0
        toFakeHeader.alpha = 0
        toVC.headerView.alpha = 0
        toVC.garlandCollection.alpha = 0
        fromVC.headerView.alpha = 0
        fromVC.garlandCollection.alpha = 0
        
        AnimationHelper.perspectiveTransformForContainerView(containerView: containerView)
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeLinear, animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25, animations: {
                toHeaderSnapshot.alpha = 1
                //toFakeHeaderSnapshot.alpha = 0
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.3, animations: {
                overlappedCells.forEach { $0.alpha = 0 }
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: {
                
                fromHeaderSnapshot.frame = headerFromFrame
                fromFakeHeaderSnapshot.frame = headerFromFrame
                toHeaderSnapshot.frame = headerFinalFrame
                toFakeHeaderSnapshot.frame = headerFinalFrame
                
                fromHeaderSnapshot.alpha = 0.2
                toHeaderSnapshot.alpha = 1
                
                fromFakeHeader.transform = CGAffineTransform(translationX: headerStartFrame.midX - headerToFrame.midX, y: 0)
                
                for (index, snapshot) in visibleToSnapshots.enumerated() {
                    snapshot.frame.origin = convertedFromCellCoords[index]
                    snapshot.alpha = 1.0
                    snapshot.frame.size.width = cellSize[index].width
                    snapshot.frame.size.height = cellSize[index].height
                }
                for snapshot in visibleFromSnapshots {
                    snapshot.frame.size = CGSize(width: snapshot.frame.width/3, height: snapshot.frame.height/2)
                    var finalX = self.finalFromXFrame
                    if finalX == 0 {
                        finalX -= snapshot.frame.width
                    }
                    snapshot.frame.origin = CGPoint(x: finalX, y: snapshot.frame.origin.y + snapshot.frame.height/2)
                    snapshot.alpha = 0.0
                }
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.25, animations: {
                fromHeaderSnapshot.alpha = 0
                //fromFakeHeaderSnapshot.alpha = 1
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.9, relativeDuration: 0.1, animations: {
                toFakeHeader.alpha = 1
            })
        }, completion: { _ in
            
            fromFakeHeader.transform = .identity
            toVC.garlandCollection.alpha = 1.0
            toVC.headerView.alpha = 1
            toVC.leftFakeHeader.alpha = 1
            toVC.rightFakeHeader.alpha = 1
            
            for snap in visibleFromSnapshots {
                snap.removeFromSuperview()
            }
            for snap in visibleToSnapshots {
                snap.removeFromSuperview()
            }
            leftFakeHeaderSnapshot.removeFromSuperview()
            rightFakeHeaderSnapshot.removeFromSuperview()
            fromHeaderSnapshot.removeFromSuperview()
            toHeaderSnapshot.removeFromSuperview()
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


extension CGRect {
    init(center: CGPoint, size: CGSize) {
        self.origin = CGPoint(x: center.x - size.width/2, y: center.y - size.height/2)
        self.size = CGSize(width: size.width, height: size.height)
    }
    
    public var center: CGPoint { return CGPoint(x: midX, y: midY) }
}
