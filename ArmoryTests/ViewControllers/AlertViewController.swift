//
//  AlertViewController.swift
//  ArmoryTests
//
//  Created by Cameron Smith on 6/12/18.
//  Copyright © 2018 stablekernel. All rights reserved.
//

import UIKit

class AlertViewController: TestViewController {

    // MARK: - Properties

    private(set) var alertController: UIAlertController!

    // MARK: - IBOutlets

    @IBOutlet weak var showAlertButton: UIButton!

    // MARK: - IBActions

    @IBAction func showAlertButtonTapped(_ sender: Any) {
        present(alertController, animated: true, completion: nil)
    }

    // MARK: - Public

    func setupAlertController(style: UIAlertControllerStyle, title: String? = nil, message: String? = nil, actions: [UIAlertAction] = []) {
        alertController = UIAlertController(title: title, message: message, preferredStyle: style)

        actions.forEach { alertController.addAction($0) }
    }
}
