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
    open var header: UIView = UIView()
    
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
        self.header.frame.size = GarlandConfig.shared.cardsSize
        self.header.frame.origin.x = UIScreen.main.bounds.width/2 - self.header.frame.width/2
        self.header.frame.origin.y = garlandView.frame.origin.y + GarlandConfig.shared.parallaxHeaderOffset - header.frame.height
        self.header.backgroundColor = .black
        self.header.tag = 99
        self.garlandView.collectionView.insertSubview(header, at: 99)
        self.garlandView.collectionView.contentInset.top = GarlandConfig.shared.cardsSize.height + GarlandConfig.shared.cardsSpacing
//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture))
//        self.view.addGestureRecognizer(panGesture)
    }
    
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
