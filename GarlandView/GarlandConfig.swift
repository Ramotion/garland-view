//
//  GarlandConfig.swift
//  GarlandView
//
//  Created by Slava Юсупов on 11.06.17.
//  Copyright © 2017 Ramotion Inc. All rights reserved.
//

import UIKit

/// Configuration struct.
/// Override `shared` property to apply new configuration.
public struct GarlandConfig {
    
    /// Shared instance of configuration.
    /// Override this property or change values directly.
    public static var shared = GarlandConfig()
    
    public var parallaxHeaderOffset: CGFloat = 40
    
    /// Side insets of GlidiingCollection view.
    /// Only left & right side insets will take effect.
    public var sideInsets = UIEdgeInsets(top: 10, left: 4.5, bottom: 10, right: 4)
    
    /// Duration of animation between GlidingCollection sections.
    public var animationDuration: Double = 0.7
    
    /// Spacing between vertical stack of items.
    public var buttonsSpacing: CGFloat = 15
    
    /// Font of each element in vertical stack.
    public var buttonsFont = UIFont.systemFont(ofSize: 16)
    
    /// Scale factor of inactive sections buttons.
    public var buttonsScaleFactor: CGFloat = 0.65
    
    /// Active section button color.
    public var activeButtonColor: UIColor = .darkGray
    
    /// Inactive sections buttons color.
    public var inactiveButtonsColor: UIColor = .black
    
    /// Space between collectionView's cells.
    public var cardsSpacing: CGFloat = 30
    
    /// Size of collectionView's cells.
    public var cardsSize = CGSize(width: round(UIScreen.main.bounds.width * 0.8), height: round(UIScreen.main.bounds.height * 0.25))
    
    /// Apply parallax effect to horizontal cards.
    public var isParallaxEnabled = true
    
    /// Shadow color.
    public var cardShadowColor = UIColor.black
    
    /// Shadow offset: width - horizontal; height - vertical.
    public var cardShadowOffset = CGSize(width: 0, height: 10)
    
    /// Shadow radius or blur.
    public var cardShadowRadius: CGFloat = 20
    
    /// Shadow opacity.
    public var cardShadowOpacity: Float = 0.3
    
}
