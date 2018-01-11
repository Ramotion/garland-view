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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        closeButton.addTarget(self, action: #selector(closeButtonAction), for: .touchDown)
        
        let nib = UINib(nibName: "CardCollectionCell", bundle: nil)
        garlandCardCollection.register(nib, forCellWithReuseIdentifier: "CardCollectionCell")
    }
    
    //MARK: Actions
    @objc fileprivate func closeButtonAction() {
        dismiss(animated: true, completion: nil)
    }
}

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
