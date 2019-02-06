//
//  AppDelegate.swift
//  The Meal Planner
//
//  Created by Caleb Hester on 1/23/19.
//  Copyright © 2019 Caleb Hester. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //Set up Firebase
        FirebaseApp.configure();
        
        //Define the storyboard
        let authStoryboard: UIStoryboard = UIStoryboard(name: "Authentication", bundle: nil);
        
        let signInViewController = authStoryboard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController;
        
        //Define the tab bar storyboard
        let tabStoryboard: UIStoryboard = UIStoryboard(name: "Tabs", bundle: nil);
        
        let mainTabBarController = tabStoryboard.instantiateViewController(withIdentifier: "MainTabBarController") as! MainTabBarController;
        
        
        
        //Listen For Auth State Change
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                //The user is logged in, so display the Tab View
                self.window = UIWindow(frame: UIScreen.main.bounds);
                self.window?.rootViewController = mainTabBarController;
                self.window?.makeKeyAndVisible();
            } else {
                //The user is not logged in, so we display the SignInView
                self.window = UIWindow(frame: UIScreen.main.bounds);
                self.window?.rootViewController = signInViewController;
                self.window?.makeKeyAndVisible();
            }
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

