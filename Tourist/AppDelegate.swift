//
//  AppDelegate.swift
//  Favorite-Places
//
//  Created by C McGhee on 11/18/17.
//  Copyright © 2017 C McGhee. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let animationSplashVC = storyboard.instantiateViewController(withIdentifier: "AnimationSplashVC")
        self.window?.rootViewController = animationSplashVC
        self.window?.makeKeyAndVisible()
        
        // MARK: Google Keys
        GMSServices.provideAPIKey(Google_MapsKey)
        GMSPlacesClient.provideAPIKey(Google_MapsKey)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
       
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
   
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
   
    }

    func applicationDidBecomeActive(_ application: UIApplication) {

    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }


}

