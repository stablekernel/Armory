//
//  StepperViewTests.swift
//  ArmoryTests
//
//  Created by Cameron Smith on 6/20/18.
//  Copyright © 2018 stablekernel. All rights reserved.
//

import XCTest
import Foundation
import UIKit

@testable import Armory

class StepperViewTests: XCTestCase, VCTest {
    
    var viewController: StepperViewController!
    
    override func setUp() {
        super.setUp()
        
        viewController = StepperViewController()
        build()
    }
    
    override func tearDown() {
        super.tearDown()
        
        viewController = nil
    }
    
    // MARK: - UIStepper tests
    
    func testStepperWillIncrement() {
        let originalValue = viewController.stepper.value
        
        increment(viewController.stepper)
        
        XCTAssertEqual(viewController.stepper.value, originalValue + viewController.stepper.stepValue )
    }
    
    func testStepperWillDecrement() {
        let originalValue = viewController.stepper.value
        
        decrement(viewController.stepper)
        
        XCTAssertEqual(viewController.stepper.value, originalValue - viewController.stepper.stepValue)
    }
    
    func testCantExceedMaximumValue() {
        let startingValue: Double = 95
        viewController.stepper.value = startingValue
        
        let expectedValue = startingValue + viewController.stepper.stepValue
        
        increment(viewController.stepper)
        
        XCTAssertNotEqual(viewController.stepper.value, expectedValue)
        XCTAssertEqual(viewController.stepper.value, viewController.stepper.maximumValue)
    }
    
    func testCantExceedMinimumValue() {
        let startingValue: Double = 5
        viewController.stepper.value = startingValue
        
        let expectedValue = startingValue - viewController.stepper.stepValue
        
        decrement(viewController.stepper)
        
        XCTAssertNotEqual(viewController.stepper.value, expectedValue)
        XCTAssertEqual(viewController.stepper.value, viewController.stepper.minimumValue)
    }
    
}
