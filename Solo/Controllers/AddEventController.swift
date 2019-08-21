//
//  AddEventController.swift
//  Solo
//
//  Created by user157824 on 8/18/19.
//  Copyright © 2019 Nathan Tung. All rights reserved.
//

import UIKit

class AddEventController: UIViewController {
    
    
    
    @IBOutlet weak var endDateInputText: UITextField!
    @IBOutlet weak var dateInputText: UITextField!
    @IBOutlet weak var Address: UITextField!
    @IBOutlet weak var EventName: UITextField!
    @IBOutlet weak var Desc: UITextField!
    
    private var datePicker: UIDatePicker!
    private var datePicker2: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.addTarget(self, action: #selector(AddEventController.dateChanged(datePicker:)),for: .valueChanged)
        dateInputText.inputView = datePicker
        
        datePicker2 = UIDatePicker()
        datePicker2.datePickerMode = .dateAndTime
        datePicker2.addTarget(self, action: #selector(AddEventController.dateChanged2(datePicker:)), for: .valueChanged)
        endDateInputText.inputView = datePicker2
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
        self.dismiss(animated: true)
    }
    
}


/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */


