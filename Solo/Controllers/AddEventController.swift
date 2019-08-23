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
class AddEventController: UIViewController, CLLocationManagerDelegate {
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
    
    @IBOutlet weak var endDateInputText: UITextField!
    @IBOutlet weak var dateInputText: UITextField!
    @IBOutlet weak var EventName: UITextField!
    @IBOutlet weak var address: SearchTextField!
    @IBOutlet weak var Desc: UITextField!
    
    
    private var datePicker: UIDatePicker!
    private var datePicker2: UIDatePicker!
    var locationManager: CLLocationManager!
    var ref: DatabaseReference!
    var locationTable: LocationTableController!
    override func viewDidLoad() {
        super.viewDidLoad()
        //AddressSearchBar.delegate = self
        locationManager = CLLocationManager()
        locationManager.delegate = self
        ref = Database.database().reference()
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.addTarget(self, action: #selector(AddEventController.dateChanged(datePicker:)),for: .valueChanged)
        dateInputText.inputView = datePicker
        
        datePicker2 = UIDatePicker()
        datePicker2.datePickerMode = .dateAndTime
        datePicker2.addTarget(self, action: #selector(AddEventController.dateChanged2(datePicker:)), for: .valueChanged)
        endDateInputText.inputView = datePicker2
        locationTable = LocationTableController()
        locationTable.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        //Set userstoppedtypinghandler for address field
        address.userStoppedTypingHandler = {
            if let criteria = self.address.text {
                if criteria.count > 1 {
                    
                    // Show the loading indicator
                    self.address.showLoadingIndicator()
                    
                    var localRegion: MKCoordinateRegion
                    let distance: CLLocationDistance = 1200
                    
                    let currentLocation = self.locationManager.location
                    localRegion = MKCoordinateRegion(center: currentLocation?.coordinate ?? CLLocationCoordinate2D(latitude: 45, longitude: 45), latitudinalMeters: distance, longitudinalMeters: distance)
                    
                    
                    
                    guard let searchBarText = self.address.text else { return }
                    
                    let request = MKLocalSearch.Request()
                    request.naturalLanguageQuery = searchBarText
                    request.region = localRegion
                    let search = MKLocalSearch(request: request)
                    
                    search.start { response, _ in
                        guard let response = response else {
                            return
                        }
                        // Set new items to filter
                        self.address.filterStrings(response.mapItems.map({$0.name!}))
                        
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
        dateInputText.text = dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }
    @objc func dateChanged2(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd hh:mm"
        endDateInputText.text = dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }        // Do any additional setup after loading the view.
    @IBAction func doneClicked(_ sender: Any) {
        if EventName.text != ""{
            ref.child("events/\(EventName.text!)/Address").setValue(address.text ?? "None")
            ref.child("events/\(EventName.text!)/Desc").setValue(Desc.text ?? "None")
            ref.child("events/\(EventName.text!)/endDateInputText)").setValue(endDateInputText.text ?? "None")
            ref.child("events/\(EventName.text!)/dateInputText").setValue(endDateInputText.text ?? "None")
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

