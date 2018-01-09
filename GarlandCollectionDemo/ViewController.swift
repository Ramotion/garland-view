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
    
    var collectionView: UICollectionView!
    
    let scrollViewContentOffsetMargin: CGFloat = -150.0
    
    var headerIsSmall: Bool = false
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)   {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let nib = UINib(nibName: "CollectionCell", bundle: nil)
        collectionView = garlandView.collectionView
        collectionView.register(nib, forCellWithReuseIdentifier: "Cell")
        
        collectionView.backgroundColor = .clear
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.view.addSubview(collectionView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func preparePresentingToRight() {
        let secondViewController = SecondViewController.init(nibName: "SecondViewController", bundle: nil)
        secondViewController.animationXDest = UIScreen.main.bounds.width
        present(secondViewController, animated: true, completion: nil)
    }
    
    override func preparePresentingToLeft() {
        let secondViewController = SecondViewController.init(nibName: "SecondViewController", bundle: nil)
        present(secondViewController, animated: true, completion: nil)
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
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
        let startOffset = (collectionView.contentOffset.y + GarlandConfig.shared.cardsSpacing + GarlandConfig.shared.cardsSize.height) / GarlandConfig.shared.cardsSize.height
        let maxHeight: CGFloat = 1.0
        let minHeight: CGFloat = 0.7
        let minAlpha: CGFloat = 0.0

        let divided = startOffset / 3
        let offsetCounter = startOffset / 1.5
        let height = max(minHeight, min(maxHeight, 1.0 - divided))
        let alpha = max(minAlpha, min(maxHeight, 1.0 - offsetCounter))
        let avatarSize = max(minAlpha, min(maxHeight, 1.0 - offsetCounter*4))
        headerView.frame.size.height = GarlandConfig.shared.cardsSize.height*height
        avatarView.transform = CGAffineTransform(scaleX: 1.0, y: avatarSize)
        avatarView.alpha = alpha
        
        if headerView.frame.height < GarlandConfig.shared.cardsSize.height {
            self.headerView.layer.cornerRadius = 0
            self.headerView.round(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: GarlandConfig.shared.cardRadius)
        } else {
            self.headerView.layer.cornerRadius = GarlandConfig.shared.cardRadius
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print(scrollView.contentOffset.y, headerIsSmall)
        if scrollView.contentOffset.y > scrollViewContentOffsetMargin, !headerIsSmall {
            headerIsSmall = true
            scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x, y: 0.0), animated: true)
        } else if scrollView.contentOffset.y < 0.0, headerIsSmall{
            headerIsSmall = false
            scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x, y: -164.0), animated: true)
        }
    }
}

