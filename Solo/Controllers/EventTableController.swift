//
//  File.swift
//  Solo
//
//  Created by user157824 on 8/22/19.
//  Copyright © 2019 Nathan Tung. All rights reserved.
//
import UIKit
import MapKit
import Firebase
class EventTableController : UITableViewController{
    let cellId = "cellId"
    var ref: DatabaseReference!
    var eventData: Array<[String:Any]>!
    
    override func loadView(){
        super.loadView()
        
        ref = Database.database().reference()
       
        
    }
    init(data: Array<[String:Any]>){
        super.init(style: .plain)
        self.eventData = data
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
       
    
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt  indexPath: IndexPath)-> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = eventData[indexPath.row]["eventName"] as! String
      
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print(self.eventData, "yay")
        return self.eventData.count
    }
    @IBAction func backClicked(_ sender: Any) {
        self.dismiss(animated: true)
    }
}




class EventCell: UITableViewCell{

    
    var event: [String:Any]! {
        didSet {
            eventNameLabel.text = event["eventName"] as! String
            print(event["eventName"])
        }
    }
    
    private let eventNameLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textAlignment = .left
        return lbl
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(eventNameLabel)
        print("cell init")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



