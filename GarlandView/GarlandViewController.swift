//
//  GarlandViewController.swift
//  GarlandView
//
//  Created by Slava Yusupov.
//  Copyright © 2017 Ramotion. All rights reserved.
//

import Foundation
import UIKit

open class GarlandViewController: UIViewController {
    
    
    @IBOutlet open var garlandView: GarlandCollection!
    @IBOutlet open var headerView: UIView!
    open var backgroundHeader: UIView = UIView()
    
    var rightFakeHeader: UIView = UIView()
    var leftFakeHeader: UIView = UIView()
    
    
    fileprivate let garlandPresentAnimationController = GarlandPresentAnimationController()
    
    open var animationXDest: CGFloat = 0.0
    open var selectedCardIndex: IndexPath = IndexPath()
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
        setupHeader()
        setupBackground()
        setupFakeHeaders()
        self.garlandView.collectionView.contentInset.top = GarlandConfig.shared.cardsSize.height + GarlandConfig.shared.cardsSpacing
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture))
        self.view.addGestureRecognizer(panGesture)
    }
    
    func handleGesture(gesture: UIPanGestureRecognizer) {
        let velocity = gesture.velocity(in: self.view)
        let translation = gesture.translation(in: self.view)
        if velocity.x > 0, translation.x > 15, !isPresenting {
            isPresenting = true
            print("panning right")
            preparePresentingToRight()
        } else if translation.x < -15, !isPresenting {
            print("panning left")
            isPresenting = true
            preparePresentingToLeft()
        }
    }
    
    open func preparePresentingToRight() {
    
    }
    
    open func preparePresentingToLeft() {
    
    }
    
}


//MARK: Setup
public extension GarlandViewController {
    
    fileprivate func setupBackground() {
        let config = GarlandConfig.shared
        self.backgroundHeader.frame.size = CGSize(width: UIScreen.main.bounds.width, height: config.backgroundHeaderHeight)
        self.backgroundHeader.frame.origin.x = 0
        self.backgroundHeader.frame.origin.y = 0
        self.backgroundHeader.backgroundColor = UIColor(red: 68.0/255.0, green: 74.0/255.0, blue: 89.0/255.0, alpha: 1.0)
        self.view.addSubview(self.backgroundHeader)
    }
    
    fileprivate func setupFakeHeaders() {
        let config = GarlandConfig.shared
        self.rightFakeHeader.frame.size = CGSize(width: config.cardsSize.width/1.6, height: config.cardsSize.height/1.6)
        self.rightFakeHeader.frame.origin.x = UIScreen.main.bounds.width - self.rightFakeHeader.frame.width/14
        self.rightFakeHeader.frame.origin.y = garlandView.frame.origin.y + (self.headerView.frame.height - self.rightFakeHeader.frame.height)/2
        self.rightFakeHeader.backgroundColor = UIColor(red: 151.0/255.0, green: 151.0/255.0, blue: 151.0/255.0, alpha: 1.0)
        self.rightFakeHeader.layer.cornerRadius = config.cardRadius
        self.view.addSubview(self.rightFakeHeader)
        
        self.leftFakeHeader.frame.size = CGSize(width: config.cardsSize.width/1.6, height: config.cardsSize.height/1.6)
        self.leftFakeHeader.frame.origin.x = 0 - self.leftFakeHeader.frame.width + self.leftFakeHeader.frame.width/14
        self.leftFakeHeader.frame.origin.y = garlandView.frame.origin.y + (self.headerView.frame.height - self.leftFakeHeader.frame.height)/2
        self.leftFakeHeader.backgroundColor = UIColor(red: 151.0/255.0, green: 151.0/255.0, blue: 151.0/255.0, alpha: 1.0)
        self.leftFakeHeader.layer.cornerRadius = config.cardRadius
        self.view.addSubview(self.leftFakeHeader)
    }
    
    fileprivate func setupHeader() {
        self.headerView.frame.size = GarlandConfig.shared.cardsSize
        self.headerView.frame.origin.x = UIScreen.main.bounds.width/2 - self.headerView.frame.width/2
        self.headerView.frame.origin.y = garlandView.collectionView.contentOffset.y
        self.headerView.layer.cornerRadius = GarlandConfig.shared.cardRadius
        self.headerView.tag = 99
        
        self.garlandView.collectionView.insertSubview(headerView, at: 99)
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
