//
//  AppDelegate.swift
//  GarlandCollectionDemo
//
//  Created by Slava Yusupov.
//  Copyright © 2017 Ramotion. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        
        // Set Background Color of window
        window?.backgroundColor = .white
        
        // Allocate memory for an instance of the 'MainViewController' class
        let mainViewController = ViewController.init(nibName: "ViewController", bundle: nil)
        
        
        // Set the root view controller of the app's window
        window!.rootViewController = mainViewController
        
        // Make the window visible
        window!.makeKeyAndVisible()
        return true
    }
}

