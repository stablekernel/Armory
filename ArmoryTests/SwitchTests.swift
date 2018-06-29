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

enum SwitchAction {
    case didFire
}

class SwitchTests: XCTestCase, VCTest {
    
    // MARK: - Private
    
    private var actions: [SwitchAction] = []
    
    // MARK: - VCTest
    
    var viewController: SwitchViewController!
    
    // MARK: Set Up / Tear Down
    
    override func setUp() {
        super.setUp()
        
        viewController = SwitchViewController()
        build()
    }
    
    override func tearDown() {
        actions = []
        viewController = nil
        
        super.tearDown()
    }
    
    // MARK: - UISwitch tests
    
    func testSwitchAction() {
        viewController.backgroundSwitch.addTarget(self, action: #selector(switchAction(_:)), for: .valueChanged)
        
        toggle(viewController.backgroundSwitch)
        
        XCTAssertTrue(actions.contains(.didFire))
    }
    
    func testSwitchActionNotCalled() {
        viewController.backgroundSwitch.addTarget(self, action: #selector(switchAction(_:)), for: .valueChanged)
        
        viewController.backgroundSwitch.isEnabled = false
        
        toggle(viewController.backgroundSwitch)
        
        XCTAssertFalse(actions.contains(.didFire))
    }
    
}

// MARK: - Switch Action

extension SwitchTests {
    
    @objc func switchAction(_ sender: UISwitch) {
        actions.append(.didFire)
    }
}
