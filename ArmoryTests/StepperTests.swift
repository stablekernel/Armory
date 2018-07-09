//
//  StepperViewTests.swift
//  ArmoryTests
//
//  Created by Cameron Smith on 6/20/18.
//  Copyright © 2018 stablekernel. All rights reserved.
//

import XCTest
import UIKit

@testable import Armory

class StepperTests: XCTestCase, VCTestSetup {
    
    // MARK: - Private

    private var events: [UIControlEvents] = []
    
    // MARK: - VCTest
    
    var viewController: StepperViewController!
    
    // MARK: - Set Up / Tear Down
    
    override func setUp() {
        super.setUp()
        
        viewController = StepperViewController()
        build()
    }
    
    override func tearDown() {
        events = []
        viewController = nil
        
        super.tearDown()
    }
    
    // MARK: - UIStepper tests
    
    func testStepperIncrement() {
        let originalValue = viewController.stepper.value
        
        increment(viewController.stepper)
        
        XCTAssertEqual(viewController.stepper.value, originalValue + viewController.stepper.stepValue )
    }
    
    func testStepperDecrement() {
        let originalValue = viewController.stepper.value
        
        decrement(viewController.stepper)
        
        XCTAssertEqual(viewController.stepper.value, originalValue - viewController.stepper.stepValue)
    }
    
    func testStepperStopsAtMaximumValue() {
        let startingValue: Double = 95
        viewController.stepper.value = startingValue
        
        let expectedValue = startingValue + viewController.stepper.stepValue
        
        increment(viewController.stepper)
        
        XCTAssertNotEqual(viewController.stepper.value, expectedValue)
        XCTAssertEqual(viewController.stepper.value, viewController.stepper.maximumValue)
    }
    
    func testStepperStopsAtMinimumValue() {
        let startingValue: Double = 5
        viewController.stepper.value = startingValue
        
        let expectedValue = startingValue - viewController.stepper.stepValue
        
        decrement(viewController.stepper)
        
        XCTAssertNotEqual(viewController.stepper.value, expectedValue)
        XCTAssertEqual(viewController.stepper.value, viewController.stepper.minimumValue)
    }
    
    func testActionNotCalledForDisabledStepper() {
        viewController.stepper.addTarget(self, action: #selector(stepperAction(_:)), for: .valueChanged)
        
        viewController.stepper.isEnabled = false
        
        increment(viewController.stepper)
        
        XCTAssertFalse(events.contains(.valueChanged))
    }
    
    func testActionNotCalledForDecrementingAtMinimumValue() {
        viewController.stepper.addTarget(self, action: #selector(stepperAction(_:)), for: .valueChanged)
        
        viewController.stepper.value = viewController.stepper.minimumValue
        
        decrement(viewController.stepper)
        
        XCTAssertFalse(events.contains(.valueChanged))
    }
    
    func testActionNotCalledForIncrementingAtMaximumValue() {
        viewController.stepper.addTarget(self, action: #selector(stepperAction(_:)), for: .valueChanged)
        
        viewController.stepper.value = viewController.stepper.maximumValue
        
        increment(viewController.stepper)
        
        XCTAssertFalse(events.contains(.valueChanged))
    }
    
}

// MARK: - Stepper Actions

extension StepperTests {
    
    @objc func stepperAction(_ sender: UIStepper) {
        events.append(.valueChanged)
    }
}
