//
//  PickerViewTests.swift
//  ArmoryTests
//
//  Created by Cameron Smith on 6/15/18.
//  Copyright © 2018 stablekernel. All rights reserved.
//

import XCTest
import UIKit
import Foundation

@testable import Armory

class PickerViewTests: XCTestCase, VCTest {
    
    var viewController: PickerViewController!
    
    var testNames = ["John", "Jaime", "Jeremy"]
    
    override func setUp() {
        super.setUp()
        
        viewController = PickerViewController()
        build()
    }
    
    override func tearDown() {
        viewController = nil
        
        super.tearDown()
    }
    
    // MARK: - UIPickerView Tests
    
    func testPickerViewItemIsSelectable() {
        viewController.setupDataSource(names: testNames)
        
        XCTAssertEqual(viewController.pickerView.selectedRow(inComponent: 0), 0)
        
        selectItem(atRow: 1, fromPicker: viewController.pickerView, animated: true)
        
        XCTAssertEqual(viewController.pickerView.selectedRow(inComponent: 0), 1)
    }
}
