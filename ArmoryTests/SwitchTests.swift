//
//  SwitchTests.swift
//  ArmoryTests
//
//  Created by Cameron Smith on 6/19/18.
//  Copyright © 2018 stablekernel. All rights reserved.
//

import XCTest
import Foundation
import UIKit

@testable import Armory

class SwitchTests: XCTestCase, VCTest {
    
    var viewController: SwitchViewController!
    
    override func setUp() {
        super.setUp()
        
        viewController = SwitchViewController()
        build()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - UISwitch tests
    
    func testSwitchIsToggleable() {
        let initialState = viewController.backgroundSwitch.isOn
        
        toggleSwitch(viewController.backgroundSwitch)
        
        XCTAssertNotEqual(initialState, viewController.backgroundSwitch.isOn)
        XCTAssertEqual(viewController.view.backgroundColor, UIColor.blue)
    }
    
}
