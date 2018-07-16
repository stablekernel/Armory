//
//  WaitViewController.swift
//  ArmoryTests
//
//  Created by Brian Palma on 6/13/18.
//  Copyright © 2018 stablekernel. All rights reserved.
//

import UIKit

class WaitViewController: TestViewController, ModalViewControllerDelegate {

    // MARK: - IBOutlets

    @IBOutlet weak var presentModalButton: UIButton!

    // MARK: - IBActions

    @IBAction func presentModal(_ sender: UIButton) {
        let modalViewController = ModalViewController()
        modalViewController.delegate = self

        let navigationController = UINavigationController(rootViewController: modalViewController)

        present(navigationController, animated: true, completion: nil)
    }

    // MARK: - ModalViewControllerDelegate

    func done(_ viewController: ModalViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}
