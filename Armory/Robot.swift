//
//  Robot.swift
//  Armory
//
//  Created by Brian Palma on 6/11/18.
//  Copyright © 2018 stablekernel. All rights reserved.
//

import XCTest
import UIKit

class Robot<ViewControllerType: UIViewController>: VCTest {

    // MARK: - Public

    let testCase: XCTestCase
    let viewController: ViewControllerType!

    // MARK: - Initialization

    init(testClass: XCTestCase, viewController: ViewControllerType) {
        self.testCase = testClass
        self.viewController = viewController
    }

    convenience init<TestClass: XCTestCase>(_ testClass: TestClass) where TestClass: VCTest, TestClass.ViewControllerType == ViewControllerType {
        self.init(testClass: testClass, viewController: testClass.viewController)
    }

    // MARK: - VCTest

    func expectation(description: String) -> XCTestExpectation {
        return testCase.expectation(description: description)
    }

    func waitForExpectations(timeout: TimeInterval, handler: XCWaitCompletionHandler?) {
        testCase.waitForExpectations(timeout: timeout, handler: handler)
    }
}
