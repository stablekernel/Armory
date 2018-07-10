//
//  DatePickerTests.swift
//  ArmoryTests
//
//  Created by Cameron Smith on 6/15/18.
//  Copyright © 2018 stablekernel. All rights reserved.
//

import XCTest
import UIKit

@testable import Armory

class DatePickerTests: XCTestCase, ArmoryTestable {
    
    var viewController: DatePickerViewController!
    
    override func setUp() {
        super.setUp()
        
        viewController = DatePickerViewController()
        build()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - UIDatePicker Tests
    
    func testCanSetDateOnDatePicker() {
        type(viewController.dateTextField, text: "")
        
        let date = Date(timeIntervalSinceNow: 604800)
        selectDate(date, fromDatePicker: viewController.datePicker, animated: true)
        
        let toolbar = viewController.dateTextField.inputAccessoryView as! UIToolbar
        let doneButton = toolbar.items!.first!
        tap(doneButton)
        
        XCTAssertEqual(viewController.datePicker.date, date)
    }
}
