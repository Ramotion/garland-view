//
//  ViewController.swift
//  GarlandCollectionDemo
//
//  Created by Slava Юсупов on 12.06.17.
//  Copyright © 2017 Ramotion Inc. All rights reserved.
//

import UIKit
import GarlandView

class ViewController: GarlandViewController {
    
    var collectionView: UICollectionView!
    
    var latestDirection: Int = 0
    
    
    
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
        collectionView.register(UINib(nibName: "CollectionHeader", bundle: nil), forCellWithReuseIdentifier: "Header")

        collectionView.backgroundColor = .clear
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.view.addSubview(collectionView)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture))
        self.view.addGestureRecognizer(panGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleGesture(gesture: UIPanGestureRecognizer) {
        let velocity = gesture.velocity(in: self.view)
        let translation = gesture.translation(in: self.view)
        let secondViewController = SecondViewController.init(nibName: "SecondViewController", bundle: nil)
        if velocity.x > 0, translation.x > 20, !isPresenting {
            isPresenting = true
            for cell in garlandView.collectionView.visibleCells {
                let cellSnap = cell.snapshotView(afterScreenUpdates: true)
                cellSnap?.frame = cell.frame
            }
            print("panning right")
            self.animationXDest = 0
            present(secondViewController, animated: true, completion: nil)
        } else if translation.x < -20, !isPresenting {
            print("panning left")
            isPresenting = true
            secondViewController.animationXDest = UIScreen.main.bounds.width
            present(secondViewController, animated: true, completion: nil)
        }
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
        cell.contentView.clipsToBounds = true
        
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

