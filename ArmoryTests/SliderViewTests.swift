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

enum SliderAction {
    case didFire
}

class SliderViewTests: XCTestCase, VCTest {
    
    // MARK: - Private
    
    private var actions: [SliderAction] = []
    
    // MARK: - VCTest
    
    var viewController: SliderViewController!
    
    // MARK: - Set Up / Tear Down
    
    override func setUp() {
        super.setUp()
        
        viewController = SliderViewController()
        build()
    }
    
    override func tearDown() {
        actions = []
        viewController = nil
        
        super.tearDown()
    }
    
    // MARK: - UISlider tests
    
    func testNegativeMinNegativeMax() {
        viewController.slider.minimumValue = -5
        viewController.slider.maximumValue = -2
        
        slide(viewController.slider, toNormalizedValue: 0.5)
        
        XCTAssertEqual(viewController.slider.value, -3.5)
    }
    
    func testNegativeMinPositiveMax() {
        viewController.slider.minimumValue = -5
        viewController.slider.maximumValue = 5
        
        slide(viewController.slider, toNormalizedValue: 0.5)
        
        XCTAssertEqual(viewController.slider.value, 0)
    }
    
    func testPositiveMinPositiveMax() {
        viewController.slider.minimumValue = 5
        viewController.slider.maximumValue = 25
        
        slide(viewController.slider, toNormalizedValue: 0.5)
        
        XCTAssertEqual(viewController.slider.value, 15)
    }
    
    func testZeroMinZeroMax() {
        viewController.slider.minimumValue = 0
        viewController.slider.maximumValue = 0
        
        slide(viewController.slider, toNormalizedValue: 0.5)
        
        XCTAssertEqual(viewController.slider.value, 0)
    }
    
    func testNormalizedValueGreaterThanOne() {
        slide(viewController.slider, toNormalizedValue: 1.5)
        
        XCTAssertEqual(viewController.slider.value, viewController.slider.maximumValue)
    }
    
    func testNormalizedValueLessThanZero() {
        slide(viewController.slider, toNormalizedValue: -1)
        
        XCTAssertEqual(viewController.slider.value, viewController.slider.minimumValue)
    }
    
    func testNormalizedValueIsZero() {
        slide(viewController.slider, toNormalizedValue: 0)
        
        XCTAssertEqual(viewController.slider.value, viewController.slider.minimumValue)
    }
    
    func testNormalizedValueIsOne() {
        slide(viewController.slider, toNormalizedValue: 1)
        
        XCTAssertEqual(viewController.slider.value, viewController.slider.maximumValue)
    }
    
    func testSliderAction() {
        viewController.slider.addTarget(self, action: #selector(slider(_:)), for: .valueChanged)
        
        slide(viewController.slider, toNormalizedValue: 0.75)
        
        XCTAssertTrue(actions.contains(.didFire))
    }
    
    func testSliderActionAtMinValueNotCalled() {
        viewController.slider.addTarget(self, action: #selector(slider(_:)), for: .valueChanged)
        
        viewController.slider.value = 0
        
        slide(viewController.slider, toNormalizedValue: 0)
        
        XCTAssertFalse(actions.contains(.didFire))
    }
    
    func testSliderActionAtMaxValueNotCalled() {
        viewController.slider.addTarget(self, action: #selector(slider(_:)), for: .valueChanged)
        
        viewController.slider.value = 1
        
        slide(viewController.slider, toNormalizedValue: 1)
        
        XCTAssertFalse(actions.contains(.didFire))
    }
}

// MARK: - Slider Action

extension SliderViewTests {
    
    @objc func slider(_ sender: UISlider) {
        actions.append(.didFire)
    }
}
