//
//  SliderViewTests.swift
//  ArmoryTests
//
//  Created by Cameron Smith on 6/19/18.
//  Copyright © 2018 stablekernel. All rights reserved.
//

import XCTest
import Foundation
import UIKit

@testable import Armory

class SliderViewTests: XCTestCase, VCTest {
    
    var viewController: SliderViewController!
    
    override func setUp() {
        super.setUp()
        
        viewController = SliderViewController()
        build()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - UISlider tests
    
    func testSliderCanSlideWithValidValue() {
        let newValue: Float = 0.75

        slide(viewController.slider, toValue: newValue)
        
        XCTAssertEqual(viewController.slider.value, newValue)
        XCTAssertEqual(viewController.view.backgroundColor, .blue)
    }
    
    func testSliderWillNotSlideWithInvalidValue() {
        let oldValue: Float = 0.25 // Default value in xib
        let newValue: Float = 2.00 // Max value = 1.00
        
        slide(viewController.slider, toValue: newValue)
        
        XCTAssertEqual(viewController.slider.value, oldValue)
    }
}
