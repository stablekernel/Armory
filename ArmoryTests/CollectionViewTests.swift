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
    
    func testCollectionViewItemIsSelectable() {
        viewController.setupDataSource(colors: testColors)
        pump()
        
        let row = 1
        let cell: CollectionViewCell = selectCell(atRow: row, fromCollectionView: viewController.collectionView)
        
        XCTAssertEqual(cell.color, testColors[row])
    }
}
