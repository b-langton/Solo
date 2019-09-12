//
//  AddEventController.swift
//  Solo
//
//  Created by user157824 on 8/18/19.
//  Copyright © 2019 Nathan Tung. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import CoreLocation
import SearchTextField
class AddEventController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {
    //    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        return locationTable.matchingItems.count
    //    }
    //
    //    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
    //        let selectedItem = locationTable.matchingItems[indexPath.row].placemark
    //        cell.textLabel?.text = selectedItem.name
    //        cell.detailTextLabel?.text = locationTable.parseAddress(selectedItem: selectedItem)
    //        return cell
    //    }
    
    
    @IBOutlet weak var endDate: UITextField!
    @IBOutlet weak var startDate: UITextField!
    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var address: SearchTextField!
    @IBOutlet weak var desc: UITextField!
    
    private var latitude: Double!
    private var longitude: Double!
    private var datePicker: UIDatePicker!
    private var datePicker2: UIDatePicker!
    var locationManager: CLLocationManager!
    var ref: DatabaseReference!
    
    var localRegion: MKCoordinateRegion!
    override func viewDidLoad() {
        super.viewDidLoad()
        //AddressSearchBar.delegate = self
        locationManager = CLLocationManager()
        eventName.delegate = self
        desc.delegate = self
        locationManager.delegate = self
        ref = Database.database().reference()
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.addTarget(self, action: #selector(AddEventController.dateChanged(datePicker:)),for: .valueChanged)
        startDate.inputView = datePicker
        
        datePicker2 = UIDatePicker()
        datePicker2.datePickerMode = .dateAndTime
        datePicker2.addTarget(self, action: #selector(AddEventController.dateChanged2(datePicker:)), for: .valueChanged)
        endDate.inputView = datePicker2
        
        //Set Placeholders to light gray
        endDate.attributedPlaceholder = NSAttributedString(string: "End",
                                                           attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        startDate.attributedPlaceholder = NSAttributedString(string: "Start",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        eventName.attributedPlaceholder = NSAttributedString(string: "Name",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        address.attributedPlaceholder = NSAttributedString(string: "Address",
                                                           attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        desc.attributedPlaceholder = NSAttributedString(string: "Description",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    
        

        //Set userstoppedtypinghandler for address field
        address.userStoppedTypingHandler = {
            if let criteria = self.address.text {
                if criteria.count > 1 {
                    
                    // Show the loading indicator
                    self.address.showLoadingIndicator()
                    
                    
                    let distance: CLLocationDistance = 1200
                    
                    let currentLocation = self.locationManager.location
                    self.localRegion = MKCoordinateRegion(center: currentLocation?.coordinate ?? CLLocationCoordinate2D(latitude: 45, longitude: 45), latitudinalMeters: distance, longitudinalMeters: distance)
                    
                    
                    
                    guard let searchBarText = self.address.text else { return }
                    
                    let request = MKLocalSearch.Request()
                    request.naturalLanguageQuery = searchBarText
                    request.region = self.localRegion
                    let search = MKLocalSearch(request: request)
                    
                    search.start { response, _ in
                        guard let response = response else {
                            return
                        }
                        print(response)
                        // Set new items to filter
                        self.address.filterStrings(response.mapItems.map({String(describing: $0.placemark).substring(to: String(describing: $0.placemark).range(of: "United States")?.lowerBound ?? String.Index(encodedOffset: 0))}))
                        
                        // Hide loading indicator
                        self.address.stopLoadingIndicator()
                    }
                }
            }
        }
    }
    
    @objc func dateChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd hh:mm"
        startDate.text = dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }
    @objc func dateChanged2(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd hh:mm"
        endDate.text = dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }        // Do any additional setup after loading the view.
    @IBAction func doneClicked(_ sender: Any) {


        if eventName.text != ""  && self.address?.text != ""{

            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = address.text
            request.region = localRegion
            let search = MKLocalSearch(request: request)
            search.start { response, _ in
                guard let response = response else {
                    return
                }
                self.latitude = response.mapItems[0].placemark.coordinate.latitude
                self.longitude = response.mapItems[0].placemark.coordinate.longitude
                self.ref.child("events/\(self.eventName.text!)/eventName").setValue(self.eventName.text!)
                self.ref.child("events/\(self.eventName.text!)/latitude").setValue(self.latitude ?? "None")
                self.ref.child("events/\(self.eventName.text!)/longitude").setValue(self.longitude ?? "None")
                self.ref.child("events/\(self.eventName.text!)/address").setValue(self.address.text ?? "None")
                self.ref.child("events/\(self.eventName.text!)/desc").setValue(self.desc.text ?? "None")
                self.ref.child("events/\(self.eventName.text!)/endDateInputText)").setValue(self.endDate.text ?? "None")
                self.ref.child("events/\(self.eventName.text!)/dateInputText").setValue(self.startDate.text ?? "None")
            }
           

        }
        else{
            let AlertController = UIAlertController(title: "Empty Field",message: "Please name your event in order to create it!", preferredStyle: .alert)
            AlertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default))
            self.present(AlertController, animated: true)
            
        }
        self.dismiss(animated: true)
    }
    //            self.locationTable.matchingItems = response.mapItems
    //            self.locationTable.tableView.reloadData()
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //causes keyboards to hide themselves when return is pressed or user clicks away
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func backClicked(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}

//func searchBar( _ searchBar: UISearchBar, textDidChange searchText: String){
//
//    var localRegion: MKCoordinateRegion
//    let distance: CLLocationDistance = 1200
//
//    let currentLocation = locationManager.location
//    localRegion = MKCoordinateRegion(center: currentLocation?.coordinate ?? CLLocationCoordinate2D(latitude: 45, longitude: 45), latitudinalMeters: distance, longitudinalMeters: distance)
//
//
//
//    guard let searchBarText = searchBar.text else { return }
//
//    let request = MKLocalSearch.Request()
//    request.naturalLanguageQuery = searchBarText
//    request.region = localRegion
//    let search = MKLocalSearch(request: request)
//    if locationTable.presentingViewController == nil {
//        self.present(locationTable, animated: true)
//
//
//
//    }
//    search.start { response, _ in
//        guard let response = response else {
//            return
//        }
//
//        self.locationTable.matchingItems = response.mapItems
//        self.locationTable.tableView.reloadData()
//
//    }
//
//
//
//}
//
//




/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */

