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

class AlertControllerTests: XCTestCase, VCTest {
    
    var viewController: AlertViewController!
    
    override func setUp() {
        super.setUp()
        
        viewController = AlertViewController()
        build()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - UIAlertController Tests
    
    func testCorrectAlertActionHandlerIsCalled() {
        let blueButton = UIAlertAction(title: "Blue", style: .default) { action in
            self.viewController.view.backgroundColor = .blue
        }
        
        let redButton = UIAlertAction(title: "Red", style: .default) { action in
            self.viewController.view.backgroundColor = .red
        }
        
        viewController.setupAlertController(style: .alert, title: "Change Background", message: nil, actions: [blueButton, redButton])
        
        tap(viewController.showAlertButton)
        
        tapButton(withTitle: "Red", fromAlertController: viewController.alertController)
        
        waitForDismissedViewController()
        
        XCTAssertEqual(viewController.view.backgroundColor, UIColor.red)
        XCTAssertNil(viewController.presentedViewController)
    }
    
    // MARK: - ActionSheet Tests
    
    func testActionSheetAppears() {
        viewController.setupAlertController(style: .actionSheet, title: "Alert Title")
        
        tap(viewController.showAlertButton)
        
        let _: UIAlertController = waitForPresentedViewController()
    }
    
    func testCorrectActionSheetIsCalled() {
        let blueButton = UIAlertAction(title: "Blue", style: .default) { action in
            self.viewController.view.backgroundColor = .blue
        }
        
        let redButton = UIAlertAction(title: "Red", style: .default) { action in
            self.viewController.view.backgroundColor = .red
        }
        
        viewController.setupAlertController(style: .actionSheet, title: "Change background", message: nil, actions: [blueButton, redButton])
        
        tap(viewController.showAlertButton)
        
        tapButton(withTitle: "Blue", fromAlertController: viewController.alertController)
        
        waitForDismissedViewController()
        
        XCTAssertEqual(viewController.view.backgroundColor, .blue)
        XCTAssertNil(viewController.presentedViewController)
    }
}
