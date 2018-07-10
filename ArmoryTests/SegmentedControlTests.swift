//
//  SegmentedControlTests.swift
//  ArmoryTests
//
//  Created by Cameron Smith on 6/20/18.
//  Copyright © 2018 stablekernel. All rights reserved.
//

import XCTest
import UIKit

@testable import Armory

class SegmentedControlTests: XCTestCase, VCTestSetup {
    
    // MARK: - Private
    
    private var events: [UIControlEvents] = []
    
    // MARK: - VCTest
    
    var viewController: SegmentedControlViewController!
    
    // MARK: - Set Up / Tear Down
    
    override func setUp() {
        super.setUp()
        
        viewController = SegmentedControlViewController()
        build()
    }
    
    override func tearDown() {
        viewController = nil
        events = []
        
        super.tearDown()
    }
    
    // MARK: - UISegmentedControl tests
    
    func testSelectSegmentByIndex() {
        let index = 1
        
        try! selectSegment(atIndex: index, fromSegmentedControl: viewController.indexOrTitleSegmentedControl)
        
        XCTAssertEqual(viewController.indexOrTitleSegmentedControl.selectedSegmentIndex, index)
    }
    
    func testSelectSegmentByIndexGreaterThanSegmentCount() {
        do {
            let index = viewController.indexOrTitleSegmentedControl.numberOfSegments + 1
            try selectSegment(atIndex: index, fromSegmentedControl: viewController.indexOrTitleSegmentedControl)
            XCTFail("Expected test to throw error")
        } catch let error as ArmoryError {
            XCTAssertEqual(error, ArmoryError.indexOutOfBounds)
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func testSelectSegmentByTitle() {
        viewController.indexOrTitleSegmentedControl.removeAllSegments()
        
        let titles = ["First", "Second"]
        let expectedIndex = 1
        
        for (index, title) in titles.enumerated() {
            viewController.indexOrTitleSegmentedControl.insertSegment(withTitle: title, at: index, animated: false)
        }
        
        try! selectSegment(withTitle: titles[expectedIndex], fromSegmentedControl: viewController.indexOrTitleSegmentedControl)
        
        XCTAssertEqual(viewController.indexOrTitleSegmentedControl.selectedSegmentIndex, expectedIndex)
    }
    
    func testSelectSegmentByTitleFailure() {
        do {
            try selectSegment(withTitle: "Missing title", fromSegmentedControl: viewController.indexOrTitleSegmentedControl)
            XCTFail("Expected test to throw error")
        } catch let error as ArmoryError {
            XCTAssertEqual(error, ArmoryError.titleLookupFailed)
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func testSelectSegmentByTitleMultipleMatchesFailure() {
        viewController.indexOrTitleSegmentedControl.removeAllSegments()
        
        let numberOfSegments = 2
        let title = "One"
        
        for index in 0..<numberOfSegments {
            viewController.indexOrTitleSegmentedControl.insertSegment(withTitle: title, at: index, animated: false)
        }
        
        do {
            try selectSegment(withTitle: title, fromSegmentedControl: viewController.indexOrTitleSegmentedControl)
            XCTFail("Expected test to throw error")
        } catch let error as ArmoryError {
            XCTAssertEqual(ArmoryError.multipleMatchesFound, error)
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func testSelectSegmentByImage() {
        try! selectSegment(withImage: UIImage.lock(), fromSegmentedControl: viewController.imageSegmentedControl)
        
        XCTAssertEqual(viewController.imageSegmentedControl.selectedSegmentIndex, 0)
    }
    
    func testSelectSegmentByImageFailure() {
        do {
            try selectSegment(withImage: UIImage(), fromSegmentedControl: viewController.imageSegmentedControl)
            XCTFail("Expected test to throw error")
        } catch let error as ArmoryError {
            XCTAssertEqual(error, ArmoryError.imageLookupFailed)
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func testSelectSegmentByImageMultipleMatchesFailure() {
        viewController.imageSegmentedControl.removeAllSegments()
        
        let numberOfSegments = 2
        let image = UIImage.lock()
        
        for index in 0..<numberOfSegments {
            viewController.imageSegmentedControl.insertSegment(with: image, at: index, animated: false)
        }
        
        do {
            try selectSegment(withImage: image, fromSegmentedControl: viewController.imageSegmentedControl)
            XCTFail("Expected test to throw error")
        } catch let error as ArmoryError {
            XCTAssertEqual(ArmoryError.multipleMatchesFound, error)
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func testSegmentedControlAction() {
        viewController.indexOrTitleSegmentedControl.addTarget(self, action: #selector(segmentedControl(_:)), for: .valueChanged)
        
        try! selectSegment(atIndex: 0, fromSegmentedControl: viewController.indexOrTitleSegmentedControl)
        
        XCTAssertTrue(events.contains(.valueChanged))
    }
    
    func testSegmentedControlNoAction() {
        viewController.indexOrTitleSegmentedControl.addTarget(self, action: #selector(segmentedControl(_:)), for: .valueChanged)
        
        viewController.indexOrTitleSegmentedControl.isEnabled = false
        
        try! selectSegment(atIndex: 0, fromSegmentedControl: viewController.indexOrTitleSegmentedControl)
        
        XCTAssertTrue(events.isEmpty)
    }
}

// MARK: - SegmentedControlTests

extension SegmentedControlTests {
    
    @IBAction func segmentedControl(_ segmentedControl: UISegmentedControl) {
        events.append(.valueChanged)
    }
}
