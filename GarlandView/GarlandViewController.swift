//
//  garlandCollectionController.swift
//  garlandCollection
//
//  Created by Slava Yusupov.
//  Copyright © 2017 Ramotion. All rights reserved.
//

import Foundation
import UIKit

open class GarlandViewController: UIViewController {
    
    public let garlandCollection = GarlandCollection()
    
    public var backgroundHeader = UIView()
    public private(set) var headerView = UIView()
    
    var rightFakeHeader = UIView()
    var leftFakeHeader = UIView()
    
    open var animationXDest: CGFloat = 0.0
    open var selectedCardIndex: IndexPath = IndexPath()
    open var isPresenting = false
    
    fileprivate let garlandPresentAnimationController = GarlandPresentAnimationController()
        
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        modalPresentationStyle = .custom
        transitioningDelegate = self
        
        //setup garland collection view
        garlandCollection.collectionView.contentInset.top = GarlandConfig.shared.cardsSize.height + GarlandConfig.shared.cardsSpacing
        garlandCollection.frame = CGRect(x: 0, y: GarlandConfig.shared.headerVerticalOffset, width: view.bounds.width, height: view.bounds.height - GarlandConfig.shared.headerVerticalOffset)
        garlandCollection.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(garlandCollection)
        
        setupBackground()
        setupFakeHeaders()
        
        //add horizontal pan gesture recognizer
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
    
    open func preparePresentingToRight() { }
    
    open func preparePresentingToLeft() { }
    
    open func setupHeader(_ headerView: UIView) {
        self.headerView = headerView
        headerView.frame.size = GarlandConfig.shared.headerSize
        headerView.frame.origin.x = (UIScreen.main.bounds.width - headerView.frame.width)/2
        headerView.frame.origin.y = garlandCollection.collectionView.contentOffset.y - (GarlandConfig.shared.headerSize.height - GarlandConfig.shared.cardsSize.height)/2
        headerView.tag = 99
        
        if let background = headerView.subviews.first {
            background.layer.cornerRadius = GarlandConfig.shared.cardRadius
            background.layer.masksToBounds = true
        }
        
        let config = GarlandConfig.shared
        headerView.layer.masksToBounds = false
        headerView.layer.cornerRadius = config.cardRadius
        headerView.layer.shadowOffset = config.cardShadowOffset
        headerView.layer.shadowColor = config.cardShadowColor.cgColor
        headerView.layer.shadowOpacity = config.cardShadowOpacity
        headerView.layer.shadowRadius = config.cardShadowRadius
        
        garlandCollection.collectionView.insertSubview(headerView, at: 99)
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
        let color = UIColor(red: 151.0/255.0, green: 151.0/255.0, blue: 151.0/255.0, alpha: 1.0)
        let size = CGSize(width: config.headerSize.width/1.6, height: config.headerSize.height/1.6)
        let verticalPosition = garlandCollection.frame.origin.y + (GarlandConfig.shared.headerSize.height - size.height)/2
        
        rightFakeHeader.frame.size = size
        rightFakeHeader.frame.origin.x = UIScreen.main.bounds.width - rightFakeHeader.frame.width/14
        rightFakeHeader.frame.origin.y = verticalPosition
        rightFakeHeader.backgroundColor = color
        rightFakeHeader.layer.cornerRadius = config.cardRadius
        view.addSubview(rightFakeHeader)
        
        leftFakeHeader.frame.size = size
        leftFakeHeader.frame.origin.x = -leftFakeHeader.frame.width + leftFakeHeader.frame.width/14
        leftFakeHeader.frame.origin.y = verticalPosition
        leftFakeHeader.backgroundColor = color
        leftFakeHeader.layer.cornerRadius = config.cardRadius
        view.addSubview(leftFakeHeader)
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
