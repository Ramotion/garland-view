//
//  GarlandCardController.swift
//  GarlandView
//
//  Created by Slava Yusupov.
//  Copyright © 2017 Ramotion. All rights reserved.
//

import Foundation
import UIKit

open class GarlandCardController: UIViewController {
    
    let userCardPresentAnimationController = GarlandCardPresentAnimationController()
    let userCardDismissAnimationController = GarlandCardDismissAnimationController()
    
    @IBOutlet open var garlandCardCollection: UICollectionView!
    @IBOutlet open var avatar: UIImageView!
    @IBOutlet open var card: UIView!
    @IBOutlet open var background: UIView!
    @IBOutlet open var headerImageView: UIImageView!
    @IBOutlet open var cardConstraits: [NSLayoutConstraint]!
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        view.frame = UIScreen.main.bounds
        modalPresentationStyle = .custom
        transitioningDelegate = self
        view.backgroundColor = .gray
        garlandCardCollection.bounces = true
        setupCard()
    }
    
    fileprivate func setupCard() {
        card.layer.cornerRadius = GarlandConfig.shared.cardRadius
        avatar.layer.masksToBounds = true 
        avatar.layer.cornerRadius = avatar.frame.width/2
        avatar.layer.borderWidth = 3.0
        avatar.layer.borderColor = #colorLiteral(red: 0.6901960784, green: 0.8196078431, blue: 0.4588235294, alpha: 1)
    }
}

//MARK: Transition delegate methods
extension GarlandCardController: UIViewControllerTransitioningDelegate {
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return userCardPresentAnimationController
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return userCardDismissAnimationController
    }
}


