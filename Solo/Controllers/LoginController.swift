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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let loginButton = SCSDKLoginButton() { (success : Bool, error : Error?) in
            print("success")
            }!
        
        view.addSubview(loginButton);
        
    }
    
    
    
    
    
    
    
}




