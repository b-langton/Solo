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
import SCSDKLoginKit
import SearchTextField

class MapController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var MapView: MKMapView!
    @IBOutlet weak var bitmoji: UIButton!
    @IBOutlet weak var searchBar: SearchTextField!
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Location/Map setup
        ref = Database.database().reference()
        let locationManager = CLLocationManager()
        locationManager.requestAlwaysAuthorization()
        var point: MKPointAnnotation
        let initiallocation = locationManager.location
        print(locationManager.location)
        let viewradius: CLLocationDistance = 2000
        if initiallocation != nil {
            centerMapOnLocation(location: initiallocation!)}
        //Drop map pins (Map annotations)
        for i in eventData {
            if String( describing: i["latitude"]!) != "None" && String( describing: i["longitude"]!) != "None" {
                point = MKPointAnnotation()
                point.coordinate = CLLocationCoordinate2D(latitude: Double(String(describing: i["latitude"]!)) as! CLLocationDegrees, longitude:  Double(String(describing: i["longitude"]!)) as! CLLocationDegrees)
                point.title = String(describing: i["eventName"]!)
                MapView.addAnnotation(point)
            }
        }
        searchBar.returnKeyType = UIReturnKeyType.search
        //Set userStoppedTypingHandler for searchBar
        searchBar.userStoppedTypingHandler = {
            if let criteria = self.searchBar.text {
                if criteria.count > 1 {
                    
                    // Show the loading indicator
                    self.searchBar.showLoadingIndicator()
                    var eventNames: Array<String> = []
                    for event in eventData {
                        eventNames.append(event["eventName"] as! String)
                    }
                    self.searchBar.filterStrings(eventNames)
                    self.searchBar.stopLoadingIndicator()
                }
            }
        }
        searchBar.delegate = self
    }
    
    //BEN DO THIS, NATHAN NOT GOOD WITH MAP
    func textFieldShouldReturn(_ searchBar: UITextField) -> Bool {
        //Move mapview to center on the event being searched for but still display other event pins
        return true
    } 
    
    override func viewWillAppear(_ animated: Bool) {
        guard let bitmojiurl = URL(string: bitmojiAvatarUrl) else {
            print("NO BITMOJI")
            return
        }
        let data = try? Data(contentsOf: bitmojiurl)
        if let imageData = data {
            let image = UIImage(data: imageData)
            bitmoji.setBackgroundImage(image, for: .normal)
        }
    }
    
    let regionRadius: CLLocationDistance = 1000
    
    func centerMapOnLocation(location: CLLocation){
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        MapView.setRegion(coordinateRegion, animated: true)
    }
    
    @IBAction func bitmojiClicked(_ sender: Any) {
        print("Touched")
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}

