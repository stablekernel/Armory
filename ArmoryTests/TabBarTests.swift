//
//  TabBarTests.swift
//  ArmoryTests
//
//  Created by Brian Palma on 6/20/18.
//  Copyright © 2018 stablekernel. All rights reserved.
//

import XCTest
import UIKit

@testable import Armory

class TabBarTests: XCTestCase, VCTestSetup {

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
        let selectedViewController: UIViewController = selectTab(atIndex: 1, fromTabBar: viewController.tabBar)

        XCTAssertEqual(selectedViewController, tabTwoViewController)
    }

    func testSelectTabByTitle() {
        var selectedViewController: UIViewController

        selectedViewController = selectTab(withTitle: "Red", fromTabBar: viewController.tabBar)
        XCTAssertEqual(selectedViewController, tabOneViewController)

        selectedViewController = selectTab(withTitle: "Blue", fromTabBar: viewController.tabBar)
        XCTAssertEqual(selectedViewController, tabTwoViewController)

        selectedViewController = selectTab(withTitle: "Red", fromTabBar: viewController.tabBar)
        XCTAssertEqual(selectedViewController, tabOneViewController)
    }

    func testSelectTabByImage() {
        var selectedViewController: UIViewController

        selectedViewController = selectTab(withImage: UIImage.lock(), fromTabBar: viewController.tabBar)
        XCTAssertEqual(selectedViewController, tabTwoViewController)

        selectedViewController = selectTab(withImage: UIImage.close(), fromTabBar: viewController.tabBar)
        XCTAssertEqual(selectedViewController, tabOneViewController)
    }

}

