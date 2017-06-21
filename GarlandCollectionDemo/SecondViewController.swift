//
//  SecondViewController.swift
//  GarlandView
//
//  Created by Slava Юсупов on 15.06.17.
//  Copyright © 2017 Slava Юсупов. All rights reserved.
//

import Foundation
import UIKit
import GarlandView

class SecondViewController: GarlandViewController {
    
    var collectionView: UICollectionView!
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)   {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.transitioningDelegate = self
        self.modalPresentationStyle = .custom
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 200, height: 120)
        
        let nib = UINib(nibName: "CollectionCell", bundle: nil)
        //collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView = garlandView.collectionView
        collectionView.register(nib, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = .clear
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.view.addSubview(collectionView)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture))
        self.view.addGestureRecognizer(panGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleGesture(gesture: UIPanGestureRecognizer) {
        let velocity = gesture.velocity(in: self.view)
        let translation = gesture.translation(in: self.view)
        let firstViewController = ViewController.init(nibName: "ViewController", bundle: nil)
        if velocity.x > 0, translation.x > 20, !isPresenting {
            isPresenting = true
            print("panning right")
            present(firstViewController, animated: true, completion: nil)
        } else if translation.x < -20, !isPresenting {
            print("panning left")
            isPresenting = true
            firstViewController.animationXDest = UIScreen.main.bounds.width
            present(firstViewController, animated: true, completion: nil)
        }
    }
}

extension SecondViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CollectionCell else { return UICollectionViewCell() }
        cell.contentView.clipsToBounds = true
        cell.backgroundColor = .purple
        let layer = cell.layer
        let config = GarlandConfig.shared
        layer.shadowOffset = config.cardShadowOffset
        layer.shadowColor = config.cardShadowColor.cgColor
        layer.shadowOpacity = config.cardShadowOpacity
        layer.shadowRadius = config.cardShadowRadius
        
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = indexPath.item
        print("Selected item #\(item)")
    }
}
