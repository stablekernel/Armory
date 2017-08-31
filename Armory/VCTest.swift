//
//  VCTest.swift
//  Armory
//
//  Created by Joe Conway on 8/29/17.
//  Copyright © 2017 stablekernel. All rights reserved.
//

import Foundation

protocol VCTest {
    associatedtype T: UIViewController
    
    var viewController: T! { get }
    
    func build()
    
    func tap(_ control: UIControl)
    
    func type(_ control: UITextField, text: String)
    
    func pump()
    
    func harness(_ vc: UIViewController)
}


extension VCTest {
    func build() {
        harness(viewController)
    }
    
    func tap(_ control: UIControl) {
        // Should make sure we *can* tap it
        control.sendActions(for: UIControlEvents.touchUpInside)
        pump()
    }
    
    func type(_ control: UITextField, text: String) {
        // Should make sure it can be become first responder via tap
        control.becomeFirstResponder()
        pump()
        
        for c in text.characters {
            control.insertText(String(c))
            pump()
        }
    }
    
    func pump() {
        RunLoop.current.limitDate(forMode: RunLoopMode.defaultRunLoopMode)
    }
    
    func harness(_ vc: UIViewController) {
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 320, height: 500))
        window.rootViewController = vc
        window.makeKeyAndVisible()
        pump()
    }
}
