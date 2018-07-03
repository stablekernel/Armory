//
//  AlertControllerTests.swift
//  ArmoryTests
//
//  Created by Cameron Smith on 6/12/18.
//  Copyright © 2018 stablekernel. All rights reserved.
//

import XCTest
import Foundation
import UIKit

@testable import Armory

enum AlertAction {
    case blue
    case red
}

class AlertControllerTests: XCTestCase, VCTest {
    
    // MARK: - Private
    
    private lazy var alertActions: [UIAlertAction] = {
        let blueAction = UIAlertAction(title: "Blue", style: .default) { action in
            self.calledAlertActions.append(.blue)
        }
        
        let redAction = UIAlertAction(title: "Red", style: .default) { action in
            self.calledAlertActions.append(.red)
        }
        
        return [blueAction, redAction]
    }()
    
    private var calledAlertActions: [AlertAction] = []
    
    // MARK: - VCTest
    
    var viewController: AlertViewController!
    
    // MARK: - Set Up / Tear Down
    
    override func setUp() {
        super.setUp()
        
        viewController = AlertViewController()
        build()
    }
    
    override func tearDown() {
        calledAlertActions = []
        viewController = nil
        
        super.tearDown()
    }
    
    // MARK: - UIAlertController Tests
    
    func testRedAlertActionForAlertStyle() {
        viewController.setupAlertController(style: .alert, title: "Change Background", actions: alertActions)
        
        tap(viewController.showAlertButton)
        
        try! tapButton(withTitle: "Red", fromAlertController: viewController.alertController)
        
        waitForDismissedViewController()
        
        XCTAssertTrue(self.calledAlertActions.elementsEqual([.red]))
    }
    
    func testBlueAlertActionForActionSheetStyle() {
        viewController.setupAlertController(style: .actionSheet, title: "Change background", actions: alertActions)
        
        tap(viewController.showAlertButton)
        
        try! tapButton(withTitle: "Blue", fromAlertController: viewController.alertController)
        
        waitForDismissedViewController()
        
        XCTAssertTrue(self.calledAlertActions.elementsEqual([.blue]))
    }
    
    func testAlertActionForAlertStyleFailure() {
        viewController.setupAlertController(style: .alert, title: "Change Background", actions: alertActions)
        
        tap(viewController.showAlertButton)
        
        do {
            try tapButton(withTitle: "Invalid", fromAlertController: viewController.alertController)
        } catch let error as ArmoryError {
            XCTAssertEqual(error, ArmoryError.titleLookupFailed)
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func testAlertActionForActionSheetStyleFailure() {
        viewController.setupAlertController(style: .actionSheet, title: "Change Background", actions: alertActions)
        
        tap(viewController.showAlertButton)
        
        do {
            try tapButton(withTitle: "Invalid", fromAlertController: viewController.alertController)
        } catch let error as ArmoryError {
            XCTAssertEqual(error, ArmoryError.titleLookupFailed)
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func testDisabledAlertActionForAlertStyleNotCalled() {
        viewController.setupAlertController(style: .alert, title: "Change Background", actions: alertActions)
        
        alertActions.first?.isEnabled = false
        
        tap(viewController.showAlertButton)
        
        try! tapButton(withTitle: "Blue", fromAlertController: viewController.alertController)
        
        XCTAssertFalse(calledAlertActions.contains(.blue))
    }
    
    func testDisabledAlertActionForActionSheetStyleNotCalled() {
        viewController.setupAlertController(style: .actionSheet, title: "Change Background", actions: alertActions)
        
        alertActions.first?.isEnabled = false
        
        tap(viewController.showAlertButton)
        
        try! tapButton(withTitle: "Blue", fromAlertController: viewController.alertController)
        
        XCTAssertFalse(calledAlertActions.contains(.blue))
    }
}
