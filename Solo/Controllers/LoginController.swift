//
//  ViewController.swift
//  Solo
//
//  Created by Nathan Tung on 6/8/19.
//  Copyright © 2019 Nathan Tung. All rights reserved.
//

import UIKit
import SCSDKLoginKit

class LoginController: UIViewController {
    
    @IBOutlet weak var logo: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        var displayName: String!
        var bitmojiAvatarUrl: String!  
        //Create login with snapchat button
        let loginButton = SCSDKLoginButton() { (success : Bool, error : Error?) in
            if success {
                //Store boolean so user does not have to re-login
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                //Fetch user data
                let graphQLQuery = "{me{displayName, bitmoji{avatar}}}"
                
                SCSDKLoginClient.fetchUserData(withQuery: graphQLQuery, variables: nil, success: { (resources: [AnyHashable: Any]?) in
                    guard let resources = resources,
                        let data = resources["data"] as? [String: Any],
                        let me = data["me"] as? [String: Any] else { return }
                    
                    displayName = me["displayName"] as! String
                    if let bitmoji = me["bitmoji"] as? [String: Any] {
                        bitmojiAvatarUrl = bitmoji["avatar"] as! String
                    }
                }, failure: { (error: Error?, isUserLoggedOut: Bool) in
                    print("ERROR WITH FETCHING USER INFO: " + error!.localizedDescription)
                })
                //Move to map screen after login is complete
                self.dismiss(animated: true)
                return
            }
            print("ERROR WITH LOGIN: " + error!.localizedDescription)
            }!
        
        view.addSubview(loginButton)
        
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loginButton.widthAnchor.constraint(equalToConstant: 250),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            loginButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -130),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
    }
    
}







