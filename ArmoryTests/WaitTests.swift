//
//  WaitTest.swift
//  ArmoryTests
//
//  Created by Brian Palma on 6/13/18.
//  Copyright © 2018 stablekernel. All rights reserved.
//

import XCTest
import UIKit

@testable import Armory

class WaitTests: XCTestCase, ArmoryTestable {
    
    var viewController: WaitViewController!
    
    override func setUp() {
        super.setUp()
        viewController = WaitViewController()
        
        build()
    }
    
    override func tearDown() {
        viewController = nil
        
        super.tearDown()
    }
    
    func testWaitForPresentedViewController() {
        tap(viewController.presentModalButton)
        let _ = waitForPresentedViewController()
    }
    
    func testWaitForDismissedViewController() {
        tap(viewController.presentModalButton)
        
        let navigationController: UINavigationController = waitForPresentedViewController()
        let modalViewController = navigationController.topViewController as! ModalViewController
        
        tap(modalViewController.doneButton)
        
        waitForDismissedViewController()
    }
}
