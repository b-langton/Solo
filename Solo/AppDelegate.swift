//
//  AppDelegate.swift
//  Solo
//
//  Created by Nathan Tung on 6/8/19.
//  Copyright © 2019 Nathan Tung. All rights reserved.
//

import UIKit
import SCSDKLoginKit
import Firebase

var eventData: Array<[String:Any]> = []
var displayName = ""
var bitmojiAvatarUrl = ""

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var ref: DatabaseReference!
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        ref = Database.database().reference()
        ref.child("events").observeSingleEvent(of: .value, with: { (snapshot) in
            for child: DataSnapshot in snapshot.children.allObjects as! [DataSnapshot] {
                eventData.append((child.value as? [String:Any])!)
                
            }})
        print(eventData.count, "init")
        //Check if user is logged in. If they aren't, present login screen. If they are, fetch their data
        let loggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        if (!loggedIn) {
            print("LOGGEDIN")
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let launchScreen = mainStoryboard.instantiateViewController(withIdentifier: "Login")
            let launchScreenView = launchScreen.view!
            launchScreenView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            launchScreenView.frame = window!.rootViewController!.view.bounds
            window?.rootViewController?.view.addSubview(launchScreenView)
            window?.makeKeyAndVisible()
            // avoiding: Unbalanced calls to begin/end appearance transitions.
            DispatchQueue.global().async {
                DispatchQueue.main.async {
                    self.window?.rootViewController?.present(mainStoryboard.instantiateViewController(withIdentifier: "Login"), animated: false, completion: {
                        launchScreenView.removeFromSuperview()
                    })
                }
            }
        } else {
            let group = DispatchGroup()
            group.enter()
            
            DispatchQueue.main.async {
                let graphQLQuery = "{me{displayName, bitmoji{avatar}}}"
                
                SCSDKLoginClient.fetchUserData(withQuery: graphQLQuery, variables: nil, success: { (resources: [AnyHashable: Any]?) in
                    guard let resources = resources,
                        let data = resources["data"] as? [String: Any],
                        let me = data["me"] as? [String: Any] else { return }
                    
                    displayName = me["displayName"] as! String
                    if let bitmoji = me["bitmoji"] as? [String: Any] {
                        bitmojiAvatarUrl = bitmoji["avatar"] as! String
                    }
                    group.leave()
                }, failure: { (error: Error?, isUserLoggedOut: Bool) in
                    print("ERROR WITH FETCHING USER INFO: " + error!.localizedDescription)
                })
            }
            print("WAITING")
            //group.wait()
        }
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        print("WillResignActive")
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("DidEnterBackground")
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("WillEnterForeground")
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("DidBecomeActive")
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        print("WillTerminate")
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return SCSDKLoginClient.application(app, open: url, options: options)
    }
    
    
}

