import Foundation
import UIKit


struct CustomTransitionAnimator {
    
    public static func alphaPresent(using transitionContext: UIViewControllerContextTransitioning, duration: TimeInterval) {
        
        guard let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else { return }
        
        let containerView = transitionContext.containerView
        
        //configure `TO` view controller
        let toFrame = transitionContext.finalFrame(for: toVC)
        toVC.view.frame = toFrame
        containerView.addSubview(toVC.view)
        
        
        toVC.view.alpha = 0
        UIView.animate(withDuration: duration, animations: {
            toVC.view.alpha = 1
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })

    }
    
    public static func alphaDismiss(using transitionContext: UIViewControllerContextTransitioning, duration: TimeInterval, completion: @escaping () -> Void = {}) {
        
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        UIView.animate(withDuration: duration, animations: { 
            fromVC?.view.alpha = 0
        }, completion: { _ in
            completion()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
