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
        
        viewController = AlertViewController(nibName: String(describing: AlertViewController.self), bundle: Bundle(for: AlertViewController.self))
        build()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - UIAlertController Tests
    
    func testAlertControllerAppears() {
        let title = "Alert Title"
        viewController.setupAlertController(style: .alert, title: title)
        
        tap(viewController.showAlertButton)
        
        let _: UIAlertController = waitForPresentedViewController()
    }
    
    func testAlertTextFieldIsValid() {
        let title = "Alert Title"
        viewController.setupAlertController(style: .alert, title: title)
        
        let alertController = viewController.alertController
        XCTAssertEqual(alertController?.textFields?.count, 0)
        
        alertController?.addTextField(configurationHandler: nil)
        XCTAssertEqual(alertController?.textFields?.count, 1)
        
        let textField = alertController?.textFields?.first
        let text = "Lorem ipsum"
        type(textField!, text: text)
        
        XCTAssertEqual(alertController?.textFields?.first?.text, text)
    }
    
    func testAlertDismissButtonDismisses() {
        let title = "Alert Title"
        let dismissButtonTitle = "Dismiss"
        let dismissButtonAction = UIAlertAction(title: title, style: .cancel, handler: nil)
        
        viewController.setupAlertController(style: .alert, title: title, actions: [dismissButtonAction])
        
        tap(viewController.showAlertButton)
        let alertController: UIAlertController = waitForPresentedViewController()
        
        XCTAssertEqual(alertController.title, title)
        
        // TO-DO: Figure out how to programmatically call UIAlertAction button handler..
    }
    
    // MARK: - ActionSheet Tests
    func testActionSheetAppears() {
        let title = "Alert Title"
        viewController.setupAlertController(style: .actionSheet, title: title)
        
        tap(viewController.showAlertButton)
        
        let _: UIAlertController = waitForPresentedViewController()
    }
}
