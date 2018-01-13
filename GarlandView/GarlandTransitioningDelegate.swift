// Copyright © 2017 Ramotion. All rights reserved.

import Foundation

open class GarlandTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    let animationController = GarlandAnimationController()
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animationController
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animationController
    }
    
    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return animationController.isInteractive ? animationController : nil
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return animationController.isInteractive ? animationController : nil
    }
}
