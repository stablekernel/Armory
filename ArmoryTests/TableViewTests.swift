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

class TableViewTests: XCTestCase, VCTestSetup {
    
    var viewController: TableViewController!
    
    var testNames = ["John", "Jaime", "Jeremy"]
    
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
}

// MARK: - FailureCell

class FailureCell: UITableViewCell {}
