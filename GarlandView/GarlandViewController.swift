// Copyright © 2017 Ramotion. All rights reserved.

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
    internal var isPresenting = false
    
    private var transitionDelegate: GarlandTransitioningDelegate?
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        //setup garland collection view
        garlandCollection.frame = CGRect(x: 0, y: GarlandConfig.shared.headerVerticalOffset, width: view.bounds.width, height: view.bounds.height - GarlandConfig.shared.headerVerticalOffset)
        garlandCollection.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(garlandCollection)
        
        setupBackground()
        setupFakeHeaders()
        
        //add horizontal pan gesture recognizer
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture))
        panGesture.delegate = self
        view.addGestureRecognizer(panGesture)
    }
    
    //MARK: Public methods
    public func performTransition(direction: GarlandAnimationController.TransitionDirection) {
        performTransition(direction: direction, isInteractive: false)
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


//MARK: Transition methods
extension GarlandViewController: UIGestureRecognizerDelegate {
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let panGesture = gestureRecognizer as? UIPanGestureRecognizer else { return false }
        let translation = panGesture.translation(in: view)
        return translation.x != 0 && translation.y == 0
    }
    
    @objc private func handleGesture(gesture: UIPanGestureRecognizer) {
        if gesture.state == .began {
            let translation = gesture.translation(in: view)
            let direction: GarlandAnimationController.TransitionDirection = translation.x > 0 ? .right : .left
            performTransition(direction: direction, isInteractive: true)
        }
        
        if let presentedVC = (presentedViewController as? GarlandViewController),
            let transitionDelegate = presentedVC.transitioningDelegate as? GarlandTransitioningDelegate {
            transitionDelegate.animationController.handleGesture(pan: gesture)
        }
    }
    
    private func performTransition(direction: GarlandAnimationController.TransitionDirection, isInteractive: Bool) {
        guard !isPresenting else { return }
        guard let vc = nextViewController?(direction) else { return }
        isPresenting = true
        
        let transitionDelegate = GarlandTransitioningDelegate()
        transitionDelegate.animationController.transitionDirection = direction
        transitionDelegate.animationController.isInteractive = isInteractive
        if #available(iOS 10.0, *) {
            transitionDelegate.animationController.wantsInteractiveStart = isInteractive
        }
        vc.modalPresentationStyle = .custom
        vc.transitionDelegate = transitionDelegate
        vc.transitioningDelegate = transitionDelegate
        
        present(vc, animated: true, completion: nil)
    }
}


//MARK: Setup & configuration methods
private extension GarlandViewController {
    
    private func setupBackground() {
        let config = GarlandConfig.shared
        backgroundHeader.frame.size = CGSize(width: UIScreen.main.bounds.width, height: config.backgroundHeaderHeight)
        backgroundHeader.frame.origin.x = 0
        backgroundHeader.frame.origin.y = 0
        backgroundHeader.backgroundColor = config.backgroundHeaderColor
        view.insertSubview(backgroundHeader, at: 0)
    }
    
    private func setupFakeHeaders() {
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
