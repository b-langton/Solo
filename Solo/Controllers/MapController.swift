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
class MapController: UIViewController {

    @IBOutlet weak var MapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestAlwaysAuthorization()
        let initiallocation = locationManager.location
        let viewradius: CLLocationDistance = 2000
        if initiallocation != nil {
            centerMapOnLocation(location: initiallocation!)}
        // Do any additional setup after loading the view.
        
    }
    let regionRadius: CLLocationDistance = 1000
    let locationManager = CLLocationManager()
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
 

}
