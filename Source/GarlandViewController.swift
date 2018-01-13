//
//  garlandCollectionController.swift
//  garlandCollection
//
//  Copyright © 2017 Ramotion. All rights reserved.
//

import Foundation
import UIKit

open class GarlandViewController: UIViewController {
        
    public var nextViewController: ((GarlandAnimationController.TransitionDirection) -> GarlandViewController)?
    
    public let garlandCollection = GarlandCollection()
    public var backgroundHeader = UIView()
    public private(set) var headerView = UIView()
    
    let rightFakeHeader = UIView()
    let leftFakeHeader = UIView()
    
    open var animationXDest: CGFloat = 0.0
    open var selectedCardIndex: IndexPath = IndexPath()
    open var isPresenting = false
    
    fileprivate let garlandAnimationController = GarlandAnimationController()
        
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        modalPresentationStyle = .custom
        transitioningDelegate = self
        
        //setup garland collection view
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
        
        if velocity.x > 0, translation.x > 15 {
            performTransition(direction: .right)
        } else if translation.x < -15 {
            performTransition(direction: .left)
        }
    }
    
    private func performTransition(direction: GarlandAnimationController.TransitionDirection) {
        guard !isPresenting else { return }
        guard let vc = nextViewController?(direction) else { return }
        isPresenting = true
        vc.garlandAnimationController.transitionDirection = direction
        present(vc, animated: true, completion: nil)
    }
    
    open func setupHeader(_ headerView: UIView) {
        self.headerView = headerView
        garlandCollection.contentInset.top = GarlandConfig.shared.headerSize.height + GarlandConfig.shared.cardsSpacing
        
        headerView.frame.size = GarlandConfig.shared.headerSize
        headerView.frame.origin.x = (UIScreen.main.bounds.width - headerView.frame.width)/2
        headerView.frame.origin.y = garlandCollection.frame.minY
        
        view.addSubview(headerView)
    }
}


//MARK: Setup
public extension GarlandViewController {
    
    fileprivate func setupBackground() {
        let config = GarlandConfig.shared
        backgroundHeader.frame.size = CGSize(width: UIScreen.main.bounds.width, height: config.backgroundHeaderHeight)
        backgroundHeader.frame.origin.x = 0
        backgroundHeader.frame.origin.y = 0
        backgroundHeader.backgroundColor = config.backgroundHeaderColor
        view.insertSubview(backgroundHeader, at: 0)
    }
    
    fileprivate func setupFakeHeaders() {
        let config = GarlandConfig.shared
        let size = CGSize(width: config.headerSize.width/1.6, height: config.headerSize.height/1.6)
        let verticalPosition = garlandCollection.frame.origin.y + (GarlandConfig.shared.headerSize.height - size.height)/2
        
        rightFakeHeader.frame.size = size
        rightFakeHeader.frame.origin.x = UIScreen.main.bounds.width - rightFakeHeader.frame.width/14
        rightFakeHeader.frame.origin.y = verticalPosition
        rightFakeHeader.backgroundColor = config.fakeHeaderColor
        rightFakeHeader.layer.cornerRadius = config.cardRadius
        view.addSubview(rightFakeHeader)
        
        leftFakeHeader.frame.size = size
        leftFakeHeader.frame.origin.x = -leftFakeHeader.frame.width + leftFakeHeader.frame.width/14
        leftFakeHeader.frame.origin.y = verticalPosition
        leftFakeHeader.backgroundColor = config.fakeHeaderColor
        leftFakeHeader.layer.cornerRadius = config.cardRadius
        view.addSubview(leftFakeHeader)
    }
}

extension GarlandViewController: UIViewControllerTransitioningDelegate {
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return garlandAnimationController
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return garlandAnimationController
    }
}
