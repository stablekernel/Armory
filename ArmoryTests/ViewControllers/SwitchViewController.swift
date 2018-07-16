//
//  SwitchViewController.swift
//  ArmoryTests
//
//  Created by Cameron Smith on 6/19/18.
//  Copyright © 2018 stablekernel. All rights reserved.
//

import UIKit

class SwitchViewController: TestViewController {

    // MARK: - IBOutlets

    @IBOutlet weak var backgroundSwitch: UISwitch!

    // MARK: - IBActions
    @IBAction func toggleSwitch(_ sender: Any) {
        mapStateToView()
    }

    // MARK: - Private

    @objc private func mapStateToView() {
        switch backgroundSwitch.isOn {
        case true:
            view.backgroundColor = .blue
        case false:
            view.backgroundColor = .white
        }
    }
}
