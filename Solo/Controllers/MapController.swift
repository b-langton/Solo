//
//  MapController.swift
//  Solo
//
//  Created by user157824 on 8/16/19.
//  Copyright © 2019 Nathan Tung. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import UserNotifications
import Firebase

class MapController: UIViewController {
    var ref: DatabaseReference!
    @IBOutlet weak var MapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let locationManager = CLLocationManager()
        locationManager.requestAlwaysAuthorization()
        var point: MKPointAnnotation
        ref = Database.database().reference()
        ref.child("events").observeSingleEvent(of: .value, with: { (snapshot) in
            for child: DataSnapshot in snapshot.children.allObjects as! [DataSnapshot] {
                eventData.append((child.value as? [String:Any])!)
                
            }})
            print(eventData.count, "init")
        let initiallocation = locationManager.location
        print(locationManager.location)
        let viewradius: CLLocationDistance = 2000
        if initiallocation != nil {
            centerMapOnLocation(location: initiallocation!)}
        // Do any additional setup after loading the view.
        for i in eventData {
            if String( describing: i["latitude"]!) != "None" && String( describing: i["longitude"]!) != "None" {
                point = MKPointAnnotation()
                point.coordinate = CLLocationCoordinate2D(latitude: Double(String(describing: i["latitude"]!)) as! CLLocationDegrees, longitude:  Double(String(describing: i["longitude"]!)) as! CLLocationDegrees)
                point.title = String(describing: i["eventName"]!)
                MapView.addAnnotation(point)
            }
        }
        
        
        }
    let regionRadius: CLLocationDistance = 1000
    
    func centerMapOnLocation(location: CLLocation){
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        MapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    /*
    // MARK: - Navigation
     
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func addEventClicked(_ sender: Any) {
    }
}
