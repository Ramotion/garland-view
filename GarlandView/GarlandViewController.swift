//
//  GarlandViewController.swift
//  GarlandView
//
//  Created by Slava Юсупов on 15.06.17.
//  Copyright © 2017 Slava Юсупов. All rights reserved.
//

import Foundation
import UIKit

open class GarlandViewController: UIViewController {
    
    @IBOutlet open var garlandView: GarlandCollection!
    
    fileprivate let garlandPresentAnimationController = GarlandPresentAnimationController()
    
    public var delegate: GarlandCollectionDelegate?
    open var animationXDest: CGFloat = 0.0
    open var isPresenting = false
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)   {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
        self.isPresenting = false
//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture))
//        self.view.addGestureRecognizer(panGesture)
    }
    
//    func handleGesture(gesture: UIPanGestureRecognizer) {
//        let velocity = gesture.velocity(in: self.view)
//        let translation = gesture.translation(in: self.view)
//        if velocity.x > 0, translation.x > 20, !isPresenting {
//            isPresenting = true
//            print("panning right")
//            animationXDest = 0
//            delegate?.gestureWasPannedForTransition()
//            //present(secondViewController, animated: true, completion: nil)
//        } else if translation.x < -20, !isPresenting {
//            print("panning left")
//            isPresenting = true
//            animationXDest = UIScreen.main.bounds.width
//            delegate?.gestureWasPannedForTransition()
//            //present(secondViewController, animated: true, completion: nil)
//        }
//    }
    
}

extension GarlandViewController: UIViewControllerTransitioningDelegate {
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        garlandPresentAnimationController.finalFromXFrame = animationXDest
        return garlandPresentAnimationController
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return garlandPresentAnimationController
    }
}
