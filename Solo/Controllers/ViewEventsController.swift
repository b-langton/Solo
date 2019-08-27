//
//  ViewEventsController.swift
//  Solo
//
//  Created by Nathan Tung on 8/19/19.
//  Copyright © 2019 Nathan Tung. All rights reserved.
//

import Foundation
import UIKit
import Firebase
class ViewEventsController: UIViewController {
    var ref: DatabaseReference!
    var eventTableC: EventTableController!
    var bottomConstraint: NSLayoutConstraint!
    var midConstraint: NSLayoutConstraint!
    var widthConstraint: NSLayoutConstraint!
    var heightConstraint: NSLayoutConstraint!
    var eventData: Array<[String:Any]>!
    override func loadView(){
        super.loadView()
        self.eventData = []
        ref = Database.database().reference()
        ref.child("events").observeSingleEvent(of: .value, with: { (snapshot) in
            for child: DataSnapshot in snapshot.children.allObjects as! [DataSnapshot] {
                self.eventData.append((child.value as? [String:Any])!)
                
            }
            print(self.eventData.count, "init")
            self.eventTableC = EventTableController(data: self.eventData)
            self.view.addSubview(self.eventTableC.view)
            self.eventTableC.view.translatesAutoresizingMaskIntoConstraints = false
            self.bottomConstraint = self.eventTableC.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 125)
            self.midConstraint = self.eventTableC.view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 22)
            self.widthConstraint = self.eventTableC.view.widthAnchor.constraint(equalTo:self.view.widthAnchor, constant: 0)
            self.heightConstraint = self.eventTableC.view.heightAnchor.constraint(equalTo: self.view.heightAnchor, constant: 0)
            NSLayoutConstraint.activate([self.bottomConstraint, self.midConstraint, self.widthConstraint, self.heightConstraint])
        }) {(error) in
            print(error.localizedDescription)
        }
        
    
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
       
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backClicked(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}
