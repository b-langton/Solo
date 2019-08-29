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
class EventTableController : UITableViewController, CLLocationManagerDelegate{
    let cellId = "cellId"
    var ref: DatabaseReference!
    var eventData: Array<[String:Any]>!
    var locationManager: CLLocationManager!
    
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
        locationManager = CLLocationManager()
        locationManager.delegate = self
        tableView.register(EventCell.self, forCellReuseIdentifier: cellId)
       
    
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt  indexPath: IndexPath)-> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EventCell
        cell.location = locationManager.location
        cell.event = eventData[indexPath.row]
                return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return self.eventData.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath)-> CGFloat{
        return 80
    }
    @IBAction func backClicked(_ sender: Any) {
        self.dismiss(animated: true)
    }
}




class EventCell: UITableViewCell{

    var location: CLLocation!    //location must be set before event!
       
        
    
    var event: [String:Any]! {
        didSet {
            eventNameLabel.text = event["eventName"] as! String
            descriptionLabel.text = event["desc"] as! String
            startTimeLabel.text = event["dateInputText"] as! String
            if String(describing: event["latitude"]!) != "None" && String(describing: event["longitude"]!) !=  "None" && location != nil {
        
                let cellLocation = CLLocation(latitude: Double( String(describing: event["latitude"]!)) as! CLLocationDegrees, longitude: Double(String(describing: event["longitude"]!)) as! CLLocationDegrees )
                
                distanceLabel.text = String( describing: Double(Int(cellLocation.distance(from : location)/1609*100))/100) + " mi."
            }
        }
    }
    private let distanceLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .gray
        lbl.font = UIFont.systemFont(ofSize: 13)
        lbl.textAlignment = .right
        return lbl
    }()
    private let eventNameLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textAlignment = .left
        return lbl
    }()
    private let startTimeLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textAlignment = .right
        return lbl
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(distanceLabel)
        addSubview(eventNameLabel)
        addSubview(descriptionLabel)
        addSubview(startTimeLabel)
        eventNameLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft:10, paddingBottom: 0, paddingRight: 0, width: frame.size.width / 2, height: 0, enableInsets: false)
        descriptionLabel.anchor(top: eventNameLabel.bottomAnchor, left: eventNameLabel.leftAnchor, bottom: nil, right: nil, paddingTop: 3, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: frame.size.width * 0.9, height: 0, enableInsets: false)
        startTimeLabel.anchor(top: eventNameLabel.topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom:0, paddingRight: 10, width: frame.size.width/2, height: 0, enableInsets: false )
        distanceLabel.anchor(top: nil, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 5, paddingRight: 0, width: frame.size.width/3, height: 0, enableInsets: false )
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private let descriptionLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 13)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()
    
    
    
}


extension UIView {
    
    func anchor (top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat, enableInsets: Bool) {
        var topInset = CGFloat(0)
        var bottomInset = CGFloat(0)
        
        if #available(iOS 11, *), enableInsets {
            let insets = self.safeAreaInsets
            topInset = insets.top
            bottomInset = insets.bottom
            
            
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop+topInset).isActive = true
        }
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom-bottomInset).isActive = true
        }
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
    }
    
}

