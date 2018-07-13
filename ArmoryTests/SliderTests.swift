//
//  SliderViewTests.swift
//  ArmoryTests
//
//  Created by Cameron Smith on 6/19/18.
//  Copyright © 2018 stablekernel. All rights reserved.
//

import XCTest
import UIKit

@testable import Armory

class SliderTests: XCTestCase, ArmoryTestable {
    
    // MARK: - Private
    
    private var events: [UIControlEvents] = []
    
    // MARK: - Armory
    
    var viewController: SliderViewController!
    
    // MARK: - Set Up / Tear Down
    
    override func setUp() {
        super.setUp()
        
        viewController = SliderViewController()
        build()
    }
    
    override func tearDown() {
        events = []
        viewController = nil
        
        super.tearDown()
    }
    
    // MARK: - UISlider tests
    
    func testNegativeMinNegativeMax() {
        viewController.slider.minimumValue = -5
        viewController.slider.maximumValue = -2
        
        try! slide(viewController.slider, toNormalizedValue: 0.5)
        
        XCTAssertEqual(-3.5, viewController.slider.value)
    }
    
    func testNegativeMinPositiveMax() {
        viewController.slider.minimumValue = -5
        viewController.slider.maximumValue = 5
        
        try! slide(viewController.slider, toNormalizedValue: 0.5)
        
        XCTAssertEqual(0, viewController.slider.value)
    }
    
    func testPositiveMinPositiveMax() {
        viewController.slider.minimumValue = 5
        viewController.slider.maximumValue = 25
        
        try! slide(viewController.slider, toNormalizedValue: 0.5)
        
        XCTAssertEqual(15, viewController.slider.value)
    }
    
    func testZeroMinZeroMax() {
        viewController.slider.minimumValue = 0
        viewController.slider.maximumValue = 0
        
        try! slide(viewController.slider, toNormalizedValue: 0.5)
        
        XCTAssertEqual(0, viewController.slider.value)
    }
    
    func testNormalizedValueGreaterThanOne() {
        do {
            try slide(viewController.slider, toNormalizedValue: 1.5)
        } catch let error as ArmoryError {
            XCTAssertEqual(ArmoryError.invalidValue, error)
            XCTAssertTrue(events.isEmpty)
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func testNormalizedValueLessThanZero() {
        do {
            try slide(viewController.slider, toNormalizedValue: -1)
        } catch let error as ArmoryError {
            XCTAssertEqual(ArmoryError.invalidValue, error)
            XCTAssertTrue(events.isEmpty)
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func testNormalizedValueIsZero() {
        try! slide(viewController.slider, toNormalizedValue: 0)
        
        XCTAssertEqual(viewController.slider.minimumValue, viewController.slider.value)
    }
    
    func testNormalizedValueIsOne() {
        try! slide(viewController.slider, toNormalizedValue: 1)
        
        XCTAssertEqual(viewController.slider.maximumValue, viewController.slider.value)
    }
    
    func testSliderAction() {
        viewController.slider.addTarget(self, action: #selector(slider(_:)), for: .valueChanged)
        
        try! slide(viewController.slider, toNormalizedValue: 0.75)
        
        XCTAssertTrue(events.contains(.valueChanged))
    }
    
    func testSliderActionAtMinValueNotCalled() {
        viewController.slider.addTarget(self, action: #selector(slider(_:)), for: .valueChanged)
        
        viewController.slider.value = 0
        
        try! slide(viewController.slider, toNormalizedValue: 0)
        
        XCTAssert(events.isEmpty)
    }
    
    func testSliderActionAtMaxValueNotCalled() {
        viewController.slider.addTarget(self, action: #selector(slider(_:)), for: .valueChanged)
        
        viewController.slider.value = 1
        
        try! slide(viewController.slider, toNormalizedValue: 1)
        
        XCTAssert(events.isEmpty)
    }
    
    func testSliderActionNotCalled() {
        viewController.slider.addTarget(self, action: #selector(slider(_:)), for: .valueChanged)
        
        viewController.slider.isEnabled = false
        
        try! slide(viewController.slider, toNormalizedValue: 0.5)
        
        XCTAssertFalse(events.contains(.valueChanged))
    }
}

// MARK: - Slider Action

extension SliderTests {
    
    @objc func slider(_ sender: UISlider) {
        events.append(.valueChanged)
    }
}
