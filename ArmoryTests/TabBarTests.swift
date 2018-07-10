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

    var viewController: TabBarViewController!

    // MARK: - Set Up / Tear Down

    override func setUp() {
        super.setUp()

        viewController = TabBarViewController()

        build()
    }

    override func tearDown() {
        viewController = nil

        super.tearDown()
    }

    // MARK: - Tests

    func testSelectTabByIndex() {
        try! selectTab(atIndex: 0, fromTabBar: viewController.tabBar)

        XCTAssertEqual(viewController.tabOneItem, viewController.tabBar.selectedItem)
    }

    func testSelectTabByIndexLessThanZero() {
        do {
            try selectTab(atIndex: -1, fromTabBar: viewController.tabBar)
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
            try selectTab(atIndex: tabCount + 1, fromTabBar: viewController.tabBar)
            XCTFail("Expected test to throw error")
        } catch let error as ArmoryError {
            XCTAssertEqual(ArmoryError.indexOutOfBounds, error)
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }

    func testSelectTabByTitle() {
        try! selectTab(withTitle: "Index 1", fromTabBar: viewController.tabBar)

        XCTAssertEqual(viewController.tabTwoItem, viewController.tabBar.selectedItem)
    }

    func testSelectTabByTitleFailure() {
        do {
            try selectTab(withTitle: "Missing Title", fromTabBar: viewController.tabBar)
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
            try selectTab(withTitle: title, fromTabBar: viewController.tabBar)
            XCTFail("Expected test to throw error")
        } catch let error as ArmoryError {
            XCTAssertEqual(ArmoryError.multipleMatchesFound, error)
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }

    func testSelectTabByImage() {
        try! selectTab(withImage: UIImage.close(), fromTabBar: viewController.tabBar)

        XCTAssertEqual(viewController.tabTwoItem, viewController.tabBar.selectedItem)
    }

    func testSelectTabByImageFailure() {
        do {
            try selectTab(withImage: UIImage(), fromTabBar: viewController.tabBar)
            XCTFail("Expected test to throw error")
        } catch let error as ArmoryError {
            XCTAssertEqual(ArmoryError.imageLookupFailed, error)
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }

    func testSelectTabByImageFailureMultipleMatchesFailure() {
        let image = UIImage.lock()

        viewController.tabBar.items!.forEach { $0.image = image }

        do {
            try selectTab(withImage: image, fromTabBar: viewController.tabBar)
            XCTFail("Expected test to throw error")
        } catch let error as ArmoryError {
            XCTAssertEqual(ArmoryError.multipleMatchesFound, error)
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
}

