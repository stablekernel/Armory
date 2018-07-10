//
//  TabBarControllerTests.swift
//  ArmoryTests
//
//  Created by Brian Palma on 6/22/18.
//  Copyright © 2018 stablekernel. All rights reserved.
//

import XCTest
import UIKit

@testable import Armory

class TabBarControllerTests: XCTestCase, VCTestSetup {
    
    // MARK: - VCTestSetup
    
    var viewController: UITabBarController!
    
    // MARK: - Private
    
    private var tabOneViewController: UIViewController!
    private var tabTwoViewController: UIViewController!
    
    // MARK: - Set Up / Tear Down
    
    override func setUp() {
        super.setUp()
        
        tabOneViewController = UIViewController()
        tabOneViewController.tabBarItem = UITabBarItem(title: "Red", image: UIImage.close(), selectedImage: nil)
        
        tabTwoViewController = UIViewController()
        tabTwoViewController.tabBarItem = UITabBarItem(title: "Blue", image: UIImage.lock(), selectedImage: nil)
        
        viewController = UITabBarController()
        viewController.viewControllers = [tabOneViewController, tabTwoViewController]
        
        build()
        
        tabOneViewController.view.backgroundColor = .red
        tabTwoViewController.view.backgroundColor = .blue
    }
    
    override func tearDown() {
        viewController = nil
        tabOneViewController = nil
        tabTwoViewController = nil
        
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testSelectTabByIndex() {
        let selectedViewController: UIViewController = try! selectTab(atIndex: 1, fromTabBarController: viewController)
        
        XCTAssertEqual(tabTwoViewController, selectedViewController)
    }
    
    func testSelectTabByIndexLessThanZero() {
        do {
            try selectTab(atIndex: -1, fromTabBarController: viewController)
            XCTFail("Expected test to throw error")
        } catch let error as ArmoryError {
            XCTAssertEqual(ArmoryError.indexOutOfBounds, error)
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func testSelectTabByIndexGreaterThanTabCount() {
        do {
            let tabCount = viewController.tabBar.items?.count ?? 0
            try selectTab(atIndex: tabCount + 1, fromTabBarController: viewController)
            XCTFail("Expected test to throw error")
        } catch let error as ArmoryError {
            XCTAssertEqual(ArmoryError.indexOutOfBounds, error)
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func testSelectTabByTitle() {
        var selectedViewController: UIViewController
        
        selectedViewController = try! selectTab(withTitle: "Red", fromTabBarController: viewController)
        XCTAssertEqual(tabOneViewController, selectedViewController)
    }
    
    func testSelectTabByTitleFailure() {
        do {
            try selectTab(withTitle: "Missing Title", fromTabBarController: viewController)
            XCTFail("Expected test to throw error")
        } catch let error as ArmoryError {
            XCTAssertEqual(ArmoryError.titleLookupFailed, error)
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func testSelectTabByTitleMultipleMatchesFailure() {
        let title = "Tab One"
        
        viewController.tabBar.items!.forEach { $0.title = title }
        
        do {
            try selectTab(withTitle: title, fromTabBarController: viewController)
            XCTFail("Expected test to throw error")
        } catch let error as ArmoryError {
            XCTAssertEqual(ArmoryError.multipleMatchesFound, error)
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func testSelectTabByImage() {
        let selectedViewController = try! selectTab(withImage: UIImage.lock(), fromTabBarController: viewController)
        
        XCTAssertEqual(tabTwoViewController, selectedViewController)
    }
    
    func testSelectTabByImageFailure() {
        do {
            try selectTab(withImage: UIImage(), fromTabBarController: viewController)
            XCTFail("Expected test to throw error")
        } catch let error as ArmoryError {
            XCTAssertEqual(ArmoryError.imageLookupFailed, error)
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func testSelectTabByImageMultipleMatchesFailure() {
        let image = UIImage.lock()
        
        viewController.tabBar.items!.forEach { $0.image = image }
        
        do {
            try selectTab(withImage: image, fromTabBarController: viewController)
            XCTFail("Expected test to throw error")
        } catch let error as ArmoryError {
            XCTAssertEqual(ArmoryError.multipleMatchesFound, error)
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
}
