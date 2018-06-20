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
    
}
