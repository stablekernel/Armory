//
//  SegmentedControlTests.swift
//  ArmoryTests
//
//  Created by Cameron Smith on 6/20/18.
//  Copyright © 2018 stablekernel. All rights reserved.
//

import XCTest
import Foundation
import UIKit

@testable import Armory

class SegmentedControlTests: XCTestCase, VCTest {
    
    var viewController: SegmentedControlViewController!
    
    override func setUp() {
        super.setUp()
        
        viewController = SegmentedControlViewController()
        build()
    }
    
    override func tearDown() {
        super.tearDown()
        
        viewController = nil
    }
    
    // MARK: - UISegmentedControl tests
    
    func testSelectSegmentByIndex() {
        let index = 1
        
        selectSegment(viewController.segmentedControl, atIndex: index)
        
        XCTAssertEqual(viewController.segmentedControl.selectedSegmentIndex, index)
    }
    
    func testSelectSegmentByTitle() {
        let title = "Second"
        
        selectSegment(viewController.segmentedControl, withTitle: title)
        
        XCTAssertEqual(viewController.segmentedControl.titleForSegment(at: viewController.segmentedControl.selectedSegmentIndex), title)
    }
    
    func testSelectSegmentByImage() {
        viewController.setupWithImages()
        pump()
        
        let image = UIImage.lock()
        
        selectSegment(viewController.segmentedControl, withImage: image)
        
        XCTAssertEqual(viewController.segmentedControl.imageForSegment(at: 1), image)
    }
    
    func testDeselectSegments() {
        let deselectedIndex = -1
        
        selectSegment(viewController.segmentedControl, atIndex: deselectedIndex)
        
        XCTAssertEqual(viewController.segmentedControl.selectedSegmentIndex, deselectedIndex)
    }
}
