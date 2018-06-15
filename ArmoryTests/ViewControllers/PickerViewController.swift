//
//  PickerViewController.swift
//  ArmoryTests
//
//  Created by Cameron Smith on 6/15/18.
//  Copyright © 2018 stablekernel. All rights reserved.
//

import UIKit

class PickerViewController: TestViewController {
    
    // MARK: - Properties
    
    private(set) var names: [String] = []
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.dataSource = self
    }
    
    // MARK: - Public
    
    func setupDataSource(names: [String]) {
        self.names = names
        pickerView.reloadAllComponents()
    }
    
    func addName(name: String) {
        names.append(name)
        pickerView.reloadAllComponents()
    }
    
    func removeName(atIndex index: Int) {
        names.remove(at: index)
        pickerView.reloadAllComponents()
    }
}

// MARK: - UIPickerViewDataSource

extension PickerViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return names.count
    }
}
