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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Create login with snapchat button
        let loginButton = SCSDKLoginButton() { (success : Bool, error : Error?) in
            print("success")
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




