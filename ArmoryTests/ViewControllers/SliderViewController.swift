//
//  SliderViewController.swift
//  ArmoryTests
//
//  Created by Cameron Smith on 6/19/18.
//  Copyright © 2018 stablekernel. All rights reserved.
//

import UIKit

class SliderViewController: TestViewController {

    // MARK: - IBOutlets

    @IBOutlet weak var slider: UISlider!

    // MARK: - IBActions

    @IBAction func slideSlider(_ sender: Any) {
        mapStateToView()
    }

    // MARK: - Private

    private func mapStateToView() {
        switch slider.value {
        case 0..<0.5:
            view.backgroundColor = .white
        default:
            view.backgroundColor = .blue
        }
    }
}
