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
    
    var testNames = ["John","Jaime","Jeremy"]
    
    override func setUp() {
        super.setUp()
        
        viewController = PickerViewController()
        build()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - UIPickerView Tests
    
    func testValidDataSourceHasValidRows() {
        viewController.setupDataSource(names: testNames)
        
        XCTAssertEqual(viewController.pickerView.numberOfRows(inComponent: 0), testNames.count)
    }
    
    func testAddingToDataSourceInsertsNewItems() {
        viewController.setupDataSource(names: testNames)
        
        let newName = "James"
        viewController.addName(name: newName)
        
        XCTAssertEqual(viewController.pickerView.numberOfRows(inComponent: 0), testNames.count + 1)
    }
    
    func testPickerViewItemIsDeletable() {
        viewController.setupDataSource(names: testNames)
        
        viewController.removeName(atIndex: 1)
        
        XCTAssertEqual(viewController.pickerView.numberOfRows(inComponent: 0), testNames.count - 1)
    }
    
    func testPickerViewItemIsSelectable() {
        viewController.setupDataSource(names: testNames)
        
        XCTAssertEqual(viewController.pickerView.selectedRow(inComponent: 0), 0)
        
        selectItem(atRow: 1, fromPicker: viewController.pickerView, animated: true)
        
        XCTAssertEqual(viewController.pickerView.selectedRow(inComponent: 0), 1)
    }
}
