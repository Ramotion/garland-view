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
    
    open var animationXDest: CGFloat = 0.0
    open var selectedCardIndex: IndexPath = IndexPath()
    open var isPresenting = false
    
    fileprivate let garlandPresentAnimationController = GarlandPresentAnimationController()
        
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        modalPresentationStyle = .custom
        transitioningDelegate = self
        isPresenting = false
        setupBackground()
        setupFakeHeaders()
        setupHeader()
        garlandView.collectionView.contentInset.top = GarlandConfig.shared.cardsSize.height + GarlandConfig.shared.cardsSpacing
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture))
        view.addGestureRecognizer(panGesture)
    }
    
    @objc func handleGesture(gesture: UIPanGestureRecognizer) {
        let velocity = gesture.velocity(in: view)
        let translation = gesture.translation(in: view)
        if velocity.x > 0, translation.x > 15, !isPresenting {
            isPresenting = true
            preparePresentingToRight()
        } else if translation.x < -15, !isPresenting {
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
        backgroundHeader.frame.size = CGSize(width: UIScreen.main.bounds.width, height: config.backgroundHeaderHeight)
        backgroundHeader.frame.origin.x = 0
        backgroundHeader.frame.origin.y = 0
        backgroundHeader.backgroundColor = UIColor(red: 68.0/255.0, green: 74.0/255.0, blue: 89.0/255.0, alpha: 1.0)
        view.insertSubview(backgroundHeader, at: 0)
    }
    
    fileprivate func setupFakeHeaders() {
        let config = GarlandConfig.shared
        rightFakeHeader.frame.size = CGSize(width: config.cardsSize.width/1.6, height: config.cardsSize.height/1.6)
        rightFakeHeader.frame.origin.x = UIScreen.main.bounds.width - rightFakeHeader.frame.width/14
        rightFakeHeader.frame.origin.y = garlandView.frame.origin.y + (headerView.frame.height - rightFakeHeader.frame.height)/2
        rightFakeHeader.backgroundColor = UIColor(red: 151.0/255.0, green: 151.0/255.0, blue: 151.0/255.0, alpha: 1.0)
        rightFakeHeader.layer.cornerRadius = config.cardRadius
        view.addSubview(rightFakeHeader)
        
        leftFakeHeader.frame.size = CGSize(width: config.cardsSize.width/1.6, height: config.cardsSize.height/1.6)
        leftFakeHeader.frame.origin.x = 0 - leftFakeHeader.frame.width + leftFakeHeader.frame.width/14
        leftFakeHeader.frame.origin.y = garlandView.frame.origin.y + (headerView.frame.height - leftFakeHeader.frame.height)/2
        leftFakeHeader.backgroundColor = UIColor(red: 151.0/255.0, green: 151.0/255.0, blue: 151.0/255.0, alpha: 1.0)
        leftFakeHeader.layer.cornerRadius = config.cardRadius
        view.addSubview(leftFakeHeader)
    }
    
    fileprivate func setupHeader() {
        headerView.frame.size = GarlandConfig.shared.cardsSize
        headerView.frame.origin.x = UIScreen.main.bounds.width/2 - headerView.frame.width/2
        headerView.frame.origin.y = garlandView.collectionView.contentOffset.y
        headerView.layer.cornerRadius = GarlandConfig.shared.cardRadius
        headerView.tag = 99
        
        garlandView.collectionView.insertSubview(headerView, at: 99)
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
