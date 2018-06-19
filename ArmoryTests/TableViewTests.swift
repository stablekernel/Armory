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
    
    var viewController: TableViewController!
    
    var testNames = ["John", "Jaime", "Jeremy"]
    
    override func setUp() {
        super.setUp()
        
        viewController = TableViewController(nibName: nil, bundle: Bundle(for: TableViewController.self))
        build()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - UITableView Tests
    
    func testTableViewCellIsSelectable() {
        viewController.setupDataSource(names: testNames)
        pump()
        
        let row = 2
        let cell: UITableViewCell = selectCell(atRow: row, fromTableView: viewController.tableView)
        
        XCTAssertEqual(cell.textLabel?.text, testNames[2])
    }
}
