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

        XCTAssertEqual(viewController.tabBar.selectedItem, viewController.tabOneItem)
    }

    func testSelectTabByIndexLessThanZero() {
        var thrownError: ArmoryError?

        do {
            try selectTab(atIndex: -1, fromTabBar: viewController.tabBar)
        } catch let error as ArmoryError {
            thrownError = error
        } catch {
            thrownError = nil
        }

        XCTAssertEqual(thrownError, ArmoryError.indexOutOfBounds)
    }

    func testSelectTabByIndexGreaterThanTabCount() {
        var thrownError: ArmoryError?

        do {
            let tabCount = viewController.tabBar.items?.count ?? 0
            try selectTab(atIndex: tabCount + 1, fromTabBar: viewController.tabBar)
        } catch let error as ArmoryError {
            thrownError = error
        } catch {
            thrownError = nil
        }

        XCTAssertEqual(thrownError, ArmoryError.indexOutOfBounds)
    }

    func testSelectTabByTitle() {
        try! selectTab(withTitle: "Index 1", fromTabBar: viewController.tabBar)

        XCTAssertEqual(viewController.tabBar.selectedItem, viewController.tabTwoItem)
    }

    func testSelectTabByTitleFailure() {
        var thrownError: ArmoryError?

        do {
            try selectTab(withTitle: "Missing Title", fromTabBar: viewController.tabBar)
        } catch let error as ArmoryError {
            thrownError = error
        } catch {
            thrownError = nil
        }

        XCTAssertEqual(thrownError, ArmoryError.titleLookupFailed)
    }

    func testSelectTabByImage() {
        try! selectTab(withImage: UIImage.close(), fromTabBar: viewController.tabBar)

        XCTAssertEqual(viewController.tabBar.selectedItem, viewController.tabTwoItem)
    }

    func testSelectTabByImageFailure() {
        var thrownError: ArmoryError?

        do {
            try selectTab(withImage: UIImage(), fromTabBar: viewController.tabBar)
        } catch let error as ArmoryError {
            thrownError = error
        } catch {
            thrownError = nil
        }

        XCTAssertEqual(thrownError, ArmoryError.imageLookupFailed)
    }

}



