//
//  AppDelegate.swift
//  Curvature
//
//  Created by Nikhil D'Souza on 5/3/16.
//  Copyright © 2016 Nikhil D'Souza. All rights reserved.
//

import UIKit
import ResearchKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let healthStore = HKHealthStore()
    
    var window: UIWindow?
    
    var containerViewController: ResearchContainerViewController? {
        return window?.rootViewController as? ResearchContainerViewController
    }
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FIRApp.configure()
        
        let standardDefaults = UserDefaults.standard
        if standardDefaults.object(forKey: "ORKSampleFirstRun") == nil {
            ORKPasscodeViewController.removePasscodeFromKeychain()
            standardDefaults.setValue("ORKSampleFirstRun", forKey: "ORKSampleFirstRun")
        }
        
        // Appearance customization
        let pageControlAppearance = UIPageControl.appearance()
        pageControlAppearance.pageIndicatorTintColor = UIColor.lightGray
        pageControlAppearance.currentPageIndicatorTintColor = UIColor.black
        
        // Dependency injection.
        containerViewController?.injectHealthStore(healthStore)
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        lockApp()
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        if ORKPasscodeViewController.isPasscodeStoredInKeychain() {
            // Hide content so it doesn't appear in the app switcher.
            containerViewController?.contentHidden = true
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        lockApp()
    }
    
    func lockApp() {
        /*
         Only lock the app if there is a stored passcode and a passcode
         controller isn't already being shown.
         */
        guard ORKPasscodeViewController.isPasscodeStoredInKeychain() && !(containerViewController?.presentedViewController is ORKPasscodeViewController) else { return }
        
        window?.makeKeyAndVisible()
        
        let passcodeViewController = ORKPasscodeViewController.passcodeAuthenticationViewController(withText: "Welcome back to Curvature.", delegate: self) as! ORKPasscodeViewController
        containerViewController?.present(passcodeViewController, animated: false, completion: nil)
    }
}

extension AppDelegate: ORKPasscodeDelegate {
    func passcodeViewControllerDidFinish(withSuccess viewController: UIViewController) {
        containerViewController?.contentHidden = false
        viewController.dismiss(animated: true, completion: nil)
        
        var ref = FIRDatabase.database().reference()
        
        //logout user for now
//        ref.unauth()
        
        ref.observeSingleEvent({ authData in
            if authData != nil {
                // user authenticated
                print(authData)
            } else {
                self.window = UIWindow(frame: UIScreen.main.bounds)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "accountVC") 
                self.window?.rootViewController = initialViewController
                self.window?.makeKeyAndVisible()
            }
        })
    }
    
    func passcodeViewControllerDidFailAuthentication(_ viewController: UIViewController) {
    }
}


