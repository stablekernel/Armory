//
//  StepperViewController.swift
//  ArmoryTests
//
//  Created by Cameron Smith on 6/20/18.
//  Copyright © 2018 stablekernel. All rights reserved.
//

import UIKit

class StepperViewController: TestViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var label: UILabel!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapStateToView()
    }
    
    // MARK: - IBActions
    
    @IBAction func updateStepper(_ sender: Any) {
        mapStateToView()
    }
    
    // MARK: - Private
    
    private func mapStateToView() {
        label.text = "\(stepper.value)"
    }
}
