//
//  SwitchTests.swift
//  ArmoryTests
//
//  Created by Cameron Smith on 6/19/18.
//  Copyright © 2018 stablekernel. All rights reserved.
//

import XCTest
import UIKit

@testable import Armory

class SwitchTests: XCTestCase, ArmoryTestable {
    
    // MARK: - Private
    
    private var events: [UIControlEvents] = []
    
    // MARK: - Armory
    
    var viewController: SwitchViewController!
    
    // MARK: Set Up / Tear Down
    
    override func setUp() {
        super.setUp()
        
        viewController = SwitchViewController()
        build()
    }
    
    override func tearDown() {
        events = []
        viewController = nil
        
        super.tearDown()
    }
    
    // MARK: - UISwitch tests
    
    func testSwitchIsToggleable() {
        let initialState = viewController.backgroundSwitch.isOn
        
        toggle(viewController.backgroundSwitch)
        
        XCTAssertNotEqual(initialState, viewController.backgroundSwitch.isOn)
    }
    
    func testSwitchAction() {
        viewController.backgroundSwitch.addTarget(self, action: #selector(switchAction(_:)), for: .valueChanged)
        
        toggle(viewController.backgroundSwitch)
        
        XCTAssertTrue(events.contains(.valueChanged))
    }
    
    func testSwitchActionNotCalled() {
        viewController.backgroundSwitch.addTarget(self, action: #selector(switchAction(_:)), for: .valueChanged)
        
        viewController.backgroundSwitch.isEnabled = false
        
        toggle(viewController.backgroundSwitch)
        
        XCTAssertTrue(events.isEmpty)
    }
    
}

// MARK: - Switch Action

extension SwitchTests {
    
    @objc func switchAction(_ sender: UISwitch) {
        events.append(.valueChanged)
    }
}
