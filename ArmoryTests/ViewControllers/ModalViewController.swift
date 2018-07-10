//
//  ModalViewController.swift
//  ArmoryTests
//
//  Created by Brian Palma on 6/13/18.
//  Copyright © 2018 stablekernel. All rights reserved.
//

import UIKit

protocol ModalViewControllerDelegate {
    func done(_ viewController: ModalViewController)
}

class ModalViewController: TestViewController {
    
    // MARK: - Public
    
    var doneButton: UIBarButtonItem {
        return navigationItem.leftBarButtonItem!
    }
    
    var delegate: ModalViewControllerDelegate?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done(_:)))
    }
    
    // MARK: - IBActions
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        delegate?.done(self)
    }
}
