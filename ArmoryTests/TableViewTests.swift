//
//  TableViewTests.swift
//  ArmoryTests
//
//  Created by Cameron Smith on 6/13/18.
//  Copyright © 2018 stablekernel. All rights reserved.
//

import XCTest
import UIKit

@testable import Armory

class TableViewTests: XCTestCase, ArmoryTestable {

    // MARK: - Private

    private var actions: [String] = []

    // MARK: - VCTest

    var viewController: TableViewController!

    var testNames = ["John", "Jaime", "Jeremy"]

    // MARK: - Set Up / Tear Down

    override func setUp() {
        super.setUp()

        viewController = TableViewController(nibName: nil, bundle: Bundle(for: TableViewController.self))
        build()
    }

    override func tearDown() {
        super.tearDown()

        viewController = nil
    }

    // MARK: - UITableView Tests

    func testCellRetrieval() {
        viewController.setupDataSource(names: testNames)
        pump()

        let indexPath = IndexPath(row: 2, section: 0)
        let aCell: UITableViewCell = try! cell(at: indexPath, fromTableView: viewController.tableView)

        XCTAssertEqual(testNames[2], aCell.textLabel?.text)
    }

    func testCellRetrievalFailure() {
        viewController.setupDataSource(names: testNames)
        pump()

        let indexPath = IndexPath(row: 2, section: 0)

        do {
            let _: FailureCell = try cell(at: indexPath, fromTableView: viewController.tableView)
        } catch let error as ArmoryError {
            XCTAssertEqual(ArmoryError.invalidCellType, error)
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }

    func testCallTableViewActionWithTitle() {
        viewController.setupDataSource(names: testNames)
        pump()

        viewController.delegate = self

        let indexPath = IndexPath(row: 1, section: 0)
        let title = "Delete"

        let action = try! retrieveActionForCell(withTitle: title, at: indexPath, in: viewController.tableView)

        selectCellAction(action, at: indexPath)

        XCTAssertTrue(actions.contains(title))
    }

    func testCallTableViewActionWithTitleFailure() {
        viewController.setupDataSource(names: testNames)
        pump()

        viewController.delegate = self

        let indexPath = IndexPath(row: 1, section: 0)
        let title = "Invalid"

        do {
            let action = try retrieveActionForCell(withTitle: title, at: indexPath, in: viewController.tableView)
            selectCellAction(action, at: indexPath)
            XCTFail("Expected test to throw error")
        } catch let error as ArmoryError {
            XCTAssertEqual(error, ArmoryError.titleLookupFailed)
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
}

// MARK: - FailureCell

class FailureCell: UITableViewCell {}

// MARK: - TableViewControllerDelegate

extension TableViewTests: TableViewControllerDelegate {

    func didCallEditAction(withTitle title: String) {
        actions.append(title)
    }
}
