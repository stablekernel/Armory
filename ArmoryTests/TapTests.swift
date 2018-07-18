//
//  TapTests.swift
//  ArmoryTests
//
//  Created by Cameron Smith on 7/18/18.
//  Copyright © 2018 stablekernel. All rights reserved.
//

import XCTest
import UIKit

@testable import Armory

class TapTests: XCTestCase, ArmoryTestable {

    // MARK: - Private

    private var actions: [UIControlEvents] = []

    // MARK: - Armory

    var viewController: TapViewController!

    // MARK: - Set Up / Tear Down

    override func setUp() {
        super.setUp()

        viewController = TapViewController()
        build()
    }

    override func tearDown() {
        actions = []
        viewController = nil

        super.tearDown()
    }

    // MARK: - UIBarButtonItem Tests

    func testBarButtonItemActionSent() {
        viewController.toolbarBarButton.target = self
        viewController.toolbarBarButton.action = #selector(barButtonAction(_:))

        tap(viewController.toolbarBarButton)

        XCTAssertEqual([.touchUpInside], actions)
    }

    func testBarButtonItemActionNotSent() {
        viewController.toolbarBarButton.target = self
        viewController.toolbarBarButton.action = #selector(barButtonAction(_:))

        viewController.toolbarBarButton.isEnabled = false

        tap(viewController.toolbarBarButton)

        XCTAssertTrue(actions.isEmpty)
    }

    // MARK: - UIControl Tests

    func testControlActionSent() {
        viewController.centerButton.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)

        tap(viewController.centerButton)

        XCTAssertEqual([.touchUpInside], actions)
    }

    func testControlActionNotSent() {
        viewController.centerButton.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        viewController.centerButton.isEnabled = false

        tap(viewController.centerButton)

        XCTAssertTrue(actions.isEmpty)
    }
}

// MARK: - UIBarButtonItem Action

extension TapTests {

    @objc func barButtonAction(_ sender: UIBarButtonItem) {
        actions.append(.touchUpInside)
    }
}

// MARK: - UIControl Action

extension TapTests {

    @objc func buttonAction(_ sender: UIControl) {
        actions.append(.touchUpInside)
    }
}
