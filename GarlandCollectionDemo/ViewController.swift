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
        if velocity.x > 0, translation.x > 15, !isPresenting {
            isPresenting = true
            print("panning right")
            secondViewController.animationXDest = UIScreen.main.bounds.width
            present(secondViewController, animated: true, completion: nil)
        } else if translation.x < -15, !isPresenting {
            print("panning left")
            isPresenting = true
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
        let minHeight: CGFloat = 0.5

        let divided = startOffset / 3
        let height = max(minHeight, min(maxHeight, 1.0 - divided))
        headerView.frame.size.height = GarlandConfig.shared.cardsSize.height*height
    }
}

