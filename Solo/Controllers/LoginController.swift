//
//  ViewController.swift
//  Solo
//
//  Created by Nathan Tung on 6/8/19.
//  Copyright © 2019 Nathan Tung. All rights reserved.
//

import UIKit
import SCSDKLoginKit
import SnapKit

class LoginController: UIViewController {
    
    @IBOutlet weak var logo: UILabel!
    var displayName = ""
    var bitmojiAvatarUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Create login with snapchat button
        let loginButton = SCSDKLoginButton() { (success : Bool, error : Error?) in
            if success {
                //                    let graphQLQuery = "{me{displayName, bitmoji{avatar}}}"
                //
                //                    let variables = ["page": "bitmoji"]
                //
                //                    SCSDKLoginClient.fetchUserData(withQuery: graphQLQuery, variables: variables, success: { (resources: [AnyHashable: Any]?) in
                //                        guard let resources = resources,
                //                            let data = resources["data"] as? [String: Any],
                //                            let me = data["me"] as? [String: Any] else { return }
                //
                //                        self.displayName = (me["displayName"] as? String)!
                //                        if let bitmoji = me["bitmoji"] as? [String: Any] {
                //                            self.bitmojiAvatarUrl = (bitmoji["avatar"] as? String)!
                //                        }
                //                    }, failure: { (error: Error?, isUserLoggedOut: Bool) in
                //                        print(error!)
                //                    })
                print("Success")
                return
            }
            print("ERROR: " + error!.localizedDescription)
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





