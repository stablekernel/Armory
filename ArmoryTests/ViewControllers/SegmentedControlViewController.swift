//
//  SegmentedControlViewController.swift
//  ArmoryTests
//
//  Created by Cameron Smith on 6/20/18.
//  Copyright © 2018 stablekernel. All rights reserved.
//

import UIKit

class SegmentedControlViewController: TestViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    // MARK: - Public
    
    func setupWithImages() {
        segmentedControl.setImage(UIImage.close(), forSegmentAt: 0)
        segmentedControl.setImage(UIImage.lock(), forSegmentAt: 1)
    }
}
