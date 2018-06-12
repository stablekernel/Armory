//
//  AlertViewController.swift
//  ArmoryTests
//
//  Created by Cameron Smith on 6/12/18.
//  Copyright © 2018 stablekernel. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {
    
    // MARK: - Properties
    var alertController: UIAlertController!
    
    // MARK: - IBOutlets
    @IBOutlet weak var showAlertButton: UIButton!
    
    // MARK: - IBActions
    @IBAction func showAlertButtonTapped(_ sender: Any) {
        present(alertController, animated: true, completion: nil)
    }
    
    func setupAlertController(style: UIAlertControllerStyle, title: String, message: String? = nil, actions: [UIAlertAction]? = nil) {
        alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        
        let alertActions = actions ?? []
        alertActions.forEach {alertController.addAction($0)}
    }
}
