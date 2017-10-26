//
//  UserCardViewController.swift
//  GarlandView
//
//  Created by Slava Yusupov.
//  Copyright © 2017 Ramotion. All rights reserved.
//

import Foundation
import UIKit
import GarlandView

class UserCardViewController: GarlandCardController {
    
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var detailsButton: UIButton!
    @IBOutlet var collection: UICollectionView!
    
    fileprivate var isDetailed = false
    
    //var collectionView: UICollectionView!
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)   {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        closeButton.addTarget(self, action: #selector(closeButtonAction), for: .touchDown)
        //detailsButton.addTarget(self, action: #selector(detailsButtonAction), for: .touchDown)
        
        let nib = UINib(nibName: "CardCollectionCell", bundle: nil)
        collection.register(nib, forCellWithReuseIdentifier: "CardCollectionCell")
    }
    
//MARK: Actions
    @objc fileprivate func detailsButtonAction() {
        let cardConstraits = card.findSuperviewConstraints(attribute: .leading)
        
        let centerYCardConstrait = card.findSuperviewConstraints(attribute: .centerY)
        
        isDetailed = true
        for cell in self.collection.visibleCells {
            cell.layer.cornerRadius = 5.0
        }
        
        UIView.animateKeyframes(withDuration: 0.2, delay: 0, options: .calculationModeLinear, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0, animations: {
                self.card.layer.cornerRadius = 0
                cardConstraits[0].constant = 0
                centerYCardConstrait[0].constant = 100
            })
        }, completion: {_ in
            let cellSize = CGSize(width:300 , height:80)
            
            let sideInset = (self.card.frame.width - cellSize.width)/2
            
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical //.horizontal
            layout.itemSize = cellSize
            layout.sectionInset = UIEdgeInsets(top: 5, left: sideInset, bottom: 5, right: sideInset)
            layout.minimumLineSpacing = 5.0
            layout.minimumInteritemSpacing = 5.0
            self.collection.setCollectionViewLayout(layout, animated: true)
            
            self.collection.reloadData()
        })
    }
    
    @objc fileprivate func closeButtonAction() {
        dismiss(animated: true, completion: nil)
    }
}

extension UserCardViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCollectionCell", for: indexPath) as? CardCollectionCell else { return UICollectionViewCell() }
        if isDetailed {
            cell.layer.cornerRadius = 5.0
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = indexPath.item
        print("Selected item #\(item)")
    }
}
