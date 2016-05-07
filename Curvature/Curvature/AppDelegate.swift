//
//  AppDelegate.swift
//  Curvature
//
//  Created by Nikhil D'Souza on 5/3/16.
//  Copyright © 2016 Nikhil D'Souza. All rights reserved.
//

import UIKit
import ResearchKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let healthStore = HKHealthStore()
    
    var window: UIWindow?
    
    var containerViewController: ResearchContainerViewController? {
        return window?.rootViewController as? ResearchContainerViewController
    }
    
    func application(application: UIApplication, willFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        let standardDefaults = NSUserDefaults.standardUserDefaults()
        if standardDefaults.objectForKey("ORKSampleFirstRun") == nil {
            ORKPasscodeViewController.removePasscodeFromKeychain()
            standardDefaults.setValue("ORKSampleFirstRun", forKey: "ORKSampleFirstRun")
        }
        
        // Appearance customization
        let pageControlAppearance = UIPageControl.appearance()
        pageControlAppearance.pageIndicatorTintColor = UIColor.lightGrayColor()
        pageControlAppearance.currentPageIndicatorTintColor = UIColor.blackColor()
        
        // Dependency injection.
        containerViewController?.injectHealthStore(healthStore)
        return true
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        lockApp()
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        if ORKPasscodeViewController.isPasscodeStoredInKeychain() {
            // Hide content so it doesn't appear in the app switcher.
            containerViewController?.contentHidden = true
        }
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        lockApp()
    }
    
    func lockApp() {
        /*
         Only lock the app if there is a stored passcode and a passcode
         controller isn't already being shown.
         */
        guard ORKPasscodeViewController.isPasscodeStoredInKeychain() && !(containerViewController?.presentedViewController is ORKPasscodeViewController) else { return }
        
        window?.makeKeyAndVisible()
        
        let passcodeViewController = ORKPasscodeViewController.passcodeAuthenticationViewControllerWithText("Welcome back to Curvature.", delegate: self) as! ORKPasscodeViewController
        containerViewController?.presentViewController(passcodeViewController, animated: false, completion: nil)
    }
}

extension AppDelegate: ORKPasscodeDelegate {
    func passcodeViewControllerDidFinishWithSuccess(viewController: UIViewController) {
        containerViewController?.contentHidden = false
        viewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func passcodeViewControllerDidFailAuthentication(viewController: UIViewController) {
    }
}


