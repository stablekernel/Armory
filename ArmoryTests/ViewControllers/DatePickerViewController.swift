//
//  DatePickerViewController.swift
//  ArmoryTests
//
//  Created by Cameron Smith on 6/15/18.
//  Copyright © 2018 stablekernel. All rights reserved.
//

import UIKit

class DatePickerViewController: TestViewController {
    
    // MARK: - Properties
    
    var datePicker: UIDatePicker!
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var dateTextField: UITextField!
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker = UIDatePicker()
        
        // Setup toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(DatePickerViewController.dateChanged))
        toolbar.setItems([doneButton], animated: true)
        
        dateTextField.inputAccessoryView = toolbar
        dateTextField.inputView = datePicker
    }
    
    // MARK: - IBActions
    
    @objc func dateChanged() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        dateTextField.text = formatter.string(from: datePicker.date)
        view.endEditing(true)
    }
}
