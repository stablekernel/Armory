//
//  TableViewTests.swift
//  ArmoryTests
//
//  Created by Cameron Smith on 6/13/18.
//  Copyright © 2018 stablekernel. All rights reserved.
//

import XCTest
import Foundation
import UIKit

@testable import Armory

class TableViewTests: XCTestCase, VCTest {
    
    // MARK: - Private
    
    private var actions: [String] = []
    private var selectedIndexPaths: [IndexPath] = []
    
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
        viewController = nil
        actions = []
        selectedIndexPaths = []

        super.tearDown()
    }
    
    // MARK: - UITableView Tests
    
    func testCellRetrieval() {
        viewController.setupDataSource(names: testNames)
        pump()
        
        let indexPath = IndexPath(row: 2, section: 0)
        let aCell: UITableViewCell = try! cell(at: indexPath, fromTableView: viewController.tableView)
        
        XCTAssertEqual(aCell.textLabel?.text, testNames[2])
    }
    
    func testCellRetrievalFailure() {
        viewController.setupDataSource(names: testNames)
        pump()
        
        let indexPath = IndexPath(row: 2, section: 0)
        
        do {
            let _: FailureCell = try cell(at: indexPath, fromTableView: viewController.tableView)
        } catch let error as ArmoryError {
            XCTAssertEqual(error, ArmoryError.invalidCellType)
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
        
        try! selectCellAction(withTitle: title, at: indexPath, in: viewController.tableView)
        
        XCTAssertTrue(actions.contains(title))
    }
    
    func testCallTableViewActionWithTitleFailure() {
        viewController.setupDataSource(names: testNames)
        pump()
        
        viewController.delegate = self
        
        let indexPath = IndexPath(row: 1, section: 0)
        let title = "Invalid"
        
        do {
            try selectCellAction(withTitle: title, at: indexPath, in: viewController.tableView)
            XCTFail("Expected test to throw error")
        } catch let error as ArmoryError {
            XCTAssertEqual(error, ArmoryError.titleLookupFailed)
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }

    func testSelectCell() {
        viewController.setupDataSource(names: testNames)
        pump()

        viewController.delegate = self

        let indexPath = IndexPath(row: 1, section: 0)

        selectRow(at: indexPath, fromTableView: viewController.tableView)

        XCTAssertTrue(selectedIndexPaths.contains(indexPath))
    }
}

// MARK: - FailureCell

class FailureCell: UITableViewCell {}

// MARK: - TableViewControllerDelegate

extension TableViewTests: TableViewControllerDelegate {
    
    func didCallEditAction(withTitle title: String) {
        actions.append(title)
    }

    func didSelectRow(at indexPath: IndexPath) {
        selectedIndexPaths.append(indexPath)
    }
}
