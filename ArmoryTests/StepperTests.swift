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

class StepperTests: XCTestCase, ArmoryTestable {

    // MARK: - Private

    private var events: [UIControlEvents] = []

    // MARK: - Armory

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

        XCTAssertEqual(originalValue + viewController.stepper.stepValue, viewController.stepper.value)
    }

    func testStepperDecrement() {
        let originalValue = viewController.stepper.value

        decrement(viewController.stepper)

        XCTAssertEqual(originalValue - viewController.stepper.stepValue, viewController.stepper.value)
    }

    func testStepperStopsAtMaximumValue() {
        let startingValue: Double = 95
        viewController.stepper.value = startingValue

        let expectedValue = startingValue + viewController.stepper.stepValue

        increment(viewController.stepper)

        XCTAssertNotEqual(expectedValue, viewController.stepper.value)
        XCTAssertEqual(viewController.stepper.maximumValue, viewController.stepper.value)
    }

    func testStepperStopsAtMinimumValue() {
        let startingValue: Double = 5
        viewController.stepper.value = startingValue

        let expectedValue = startingValue - viewController.stepper.stepValue

        decrement(viewController.stepper)

        XCTAssertNotEqual(expectedValue, viewController.stepper.value)
        XCTAssertEqual(viewController.stepper.minimumValue, viewController.stepper.value)
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
