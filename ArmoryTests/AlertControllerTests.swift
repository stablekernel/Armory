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
    
    func testAlertControllerIsPresented() {
        viewController.setupAlertController(style: .alert, title: "Alert Title")
        
        tap(viewController.showAlertButton)
        
        let _: UIAlertController = waitForPresentedViewController()
    }
    
    func testTypingInAlertControllerTextField() {
        viewController.setupAlertController(style: .alert, title: "Alert Title")
        
        let alertController = viewController.alertController
        
        alertController?.addTextField(configurationHandler: nil)
        
        let text = "Lorem ipsum"
        type(alertController!.textFields!.first!, text: text)
        
        tap(viewController.showAlertButton)
        
        XCTAssertEqual(alertController!.textFields!.first!.text!, text)
    }
    
    func testCorrectAlertActionHandlerIsCalled() {
        let blueButton = UIAlertAction(title: "Blue", style: .default) { action in
            self.viewController.view.backgroundColor = .blue
        }
        
        let redButton = UIAlertAction(title: "Red", style: .default) { action in
            self.viewController.view.backgroundColor = .red
        }
        
        viewController.setupAlertController(style: .alert, title: "Change Background", message: nil, actions: [blueButton, redButton])
        
        tapButton(withTitle: "Red", fromAlertController: viewController.alertController)
        pump()
        
        XCTAssertEqual(viewController.view.backgroundColor, UIColor.red)
    }
    
    // MARK: - ActionSheet Tests
    
    func testActionSheetAppears() {
        viewController.setupAlertController(style: .actionSheet, title: "Alert Title")
        
        tap(viewController.showAlertButton)
        
        let _: UIAlertController = waitForPresentedViewController()
    }
}
