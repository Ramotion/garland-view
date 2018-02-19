//
//  UserCardViewController.swift
//  GarlandView
//
//  Copyright © 2017 Ramotion. All rights reserved.
//

import Foundation
import UIKit
import GarlandView

class UserCardViewController: UIViewController {
    
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var detailsButton: UIButton!
    @IBOutlet open var garlandCardCollection: UICollectionView!
    @IBOutlet open var avatar: UIImageView!
    @IBOutlet open var card: UIView!
    @IBOutlet open var background: UIView!
    @IBOutlet open var headerImageView: UIImageView!
    @IBOutlet open var cardConstraits: [NSLayoutConstraint]!
    
    fileprivate let userCardPresentAnimationController = UserCardPresentAnimationController()
    fileprivate let userCardDismissAnimationController = UserCardDismissAnimationController()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        modalPresentationStyle = .custom
        transitioningDelegate = self
        
        view.frame = UIScreen.main.bounds
        view.backgroundColor = .gray
        garlandCardCollection.bounces = true
        setupCard()
        
        closeButton.addTarget(self, action: #selector(closeButtonAction), for: .touchDown)
        
        let nib = UINib(nibName: "CardCollectionCell", bundle: nil)
        garlandCardCollection.register(nib, forCellWithReuseIdentifier: "CardCollectionCell")
    }
    
    fileprivate func setupCard() {
        card.layer.cornerRadius = GarlandConfig.shared.cardRadius
        avatar.layer.masksToBounds = true
        avatar.layer.cornerRadius = avatar.frame.width/2
        avatar.layer.borderWidth = 3.0
        avatar.layer.borderColor = #colorLiteral(red: 0.6901960784, green: 0.8196078431, blue: 0.4588235294, alpha: 1)
    }
}


//MARK: Actions
extension UserCardViewController {
    @objc fileprivate func closeButtonAction() {
        dismiss(animated: true, completion: nil)
    }
}


//MARK: UICollection view delegate & data source methods
extension UserCardViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 110)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCollectionCell", for: indexPath)
        guard let cell = collectionCell as? CardCollectionCell else {
            return UICollectionViewCell()
        }
        
        cell.contentMode = .scaleToFill
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = indexPath.item
        print("Selected item #\(item)")
    }
}


//MARK: Transition delegate methods
extension UserCardViewController: UIViewControllerTransitioningDelegate {
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return userCardPresentAnimationController
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return userCardDismissAnimationController
    }
}
