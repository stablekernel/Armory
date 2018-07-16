//
//  SegmentedControlViewController.swift
//  ArmoryTests
//
//  Created by Cameron Smith on 6/20/18.
//  Copyright © 2018 stablekernel. All rights reserved.
//

import UIKit

enum SegmentedControlSelectionMode {
    case indexOrTitle
    case image
}

class SegmentedControlViewController: TestViewController {

    // MARK: - IBOutlets

    @IBOutlet weak var imageSegmentedControl: UISegmentedControl!
    @IBOutlet weak var indexOrTitleSegmentedControl: UISegmentedControl!

}
