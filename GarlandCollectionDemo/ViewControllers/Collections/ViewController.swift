//
//  ViewController.swift
//  GarlandCollectionDemo
//
//  Created by Slava Yusupov.
//  Copyright © 2017 Ramotion. All rights reserved.
//

import UIKit
import GarlandView

class ViewController: GarlandViewController {

    @IBOutlet var avatarView: UIView!
    
    let scrollViewContentOffsetMargin: CGFloat = -150.0
    var headerIsSmall: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "CollectionCell", bundle: nil)
        let collectionView = garlandView.collectionView
        collectionView.register(nib, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    override func preparePresentingToRight() {
        showNext(disposition: UIScreen.main.bounds.width)
    }
    
    override func preparePresentingToLeft() {
        showNext(disposition: 0)
    }
    
    private func showNext(disposition: CGFloat) {
        let nextVC = ViewController.init(nibName: "ViewController", bundle: nil)
        nextVC.animationXDest = disposition
        nextVC.transitioningDelegate = nextVC
        nextVC.modalPresentationStyle = .custom
        present(nextVC, animated: true, completion: nil)
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CollectionCell else { return UICollectionViewCell() }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedCardIndex = indexPath
        let cardController = UserCardViewController.init(nibName: "UserCardViewController", bundle: nil)
        present(cardController, animated: true, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let startOffset = (garlandView.collectionView.contentOffset.y + GarlandConfig.shared.cardsSpacing + GarlandConfig.shared.cardsSize.height) / GarlandConfig.shared.cardsSize.height
        let maxHeight: CGFloat = 1.0
        let minHeight: CGFloat = 0.7
        let minAlpha: CGFloat = 0.0

        let divided = startOffset / 3
        let offsetCounter = startOffset / 1.5
        let height = max(minHeight, min(maxHeight, 1.0 - divided))
        let alpha = max(minAlpha, min(maxHeight, 1.0 - offsetCounter))
        let avatarSize = max(minAlpha, min(maxHeight, 1.0 - offsetCounter*4))
        avatarView.transform = CGAffineTransform(scaleX: 1.0, y: avatarSize)
        avatarView.alpha = alpha
        headerView.frame.size.height = GarlandConfig.shared.cardsSize.height*height
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y > scrollViewContentOffsetMargin, !headerIsSmall {
            headerIsSmall = true
            scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x, y: 0.0), animated: true)
        } else if scrollView.contentOffset.y < 0.0, headerIsSmall{
            headerIsSmall = false
            scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x, y: -164.0), animated: true)
        }
    }
}

