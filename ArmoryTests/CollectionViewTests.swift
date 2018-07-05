//
//  CollectionViewTests.swift
//  ArmoryTests
//
//  Created by Cameron Smith on 6/13/18.
//  Copyright © 2018 stablekernel. All rights reserved.
//

import XCTest
import Foundation
import UIKit

@testable import Armory

class CollectionViewTests: XCTestCase, VCTest {
    
    var viewController: CollectionViewController!
    
    var testColors = [UIColor.red, UIColor.green, UIColor.blue]
    
    override func setUp() {
        super.setUp()
        
        viewController = CollectionViewController()
        build()
    }
    
    override func tearDown() {
        super.tearDown()
        
        viewController = nil
    }
    
    // MARK: - UICollectionView Tests
    
    func testCellRetrieval() {
        viewController.setupDataSource(colors: testColors)
        pump()
        
        let indexPath = IndexPath(row: 2, section: 0)
        let aCell: CollectionViewCell = try! cell(at: indexPath, fromCollectionView: viewController.collectionView)
        
        XCTAssertEqual(aCell.color, testColors[indexPath.row])
    }
    
    func testCellRetrievalFailure() {
        viewController.setupDataSource(colors: testColors)
        pump()
        
        let indexPath = IndexPath(row: 2, section: 0)
        
        do {
            let _: FailureCollectionCell = try cell(at: indexPath, fromCollectionView: viewController.collectionView)
            XCTFail("Expected test to throw error")
        } catch let error as ArmoryError {
            XCTAssertEqual(error, ArmoryError.invalidCellType)
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
}

// MARK: - FailureCollectionCell

class FailureCollectionCell: UICollectionViewCell {}
