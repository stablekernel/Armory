//
//  VCTest.swift
//  Armory
//
//  Created by Joe Conway on 8/29/17.
//  Copyright © 2017 stablekernel. All rights reserved.
//

import Foundation
import XCTest

protocol VCTestSetup {

    func build()

    func harness(_ vc: UIViewController)
}

protocol VCTest {
    associatedtype ViewControllerType: UIViewController

    var viewController: ViewControllerType! { get }

    func tap(_ control: UIControl)
    
    func type(_ control: UITextField, text: String)
    
    func pump()
    
    func expectation(description: String) -> XCTestExpectation
    func waitForExpectations(timeout: TimeInterval, handler: XCWaitCompletionHandler?)
    
    func after(_ test: @autoclosure @escaping () -> Bool)
}


extension VCTest {
    func build() {
        harness(viewController)
        pump()
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
        
        for c in text {
            control.insertText(String(c))
            pump()
        }
    }
    
    func after(_ test: @autoclosure @escaping () -> Bool) {
        let exp = expectation(description: "Foobarxyz")
        let observer = CFRunLoopObserverCreateWithHandler(nil, CFRunLoopActivity.afterWaiting.rawValue, true, 0) { (observer, _) in
            let _ = self.viewController.view.layer.presentation()
            if test() == true {
                CFRunLoopRemoveObserver(CFRunLoopGetCurrent(), observer, CFRunLoopMode.defaultMode)
                exp.fulfill()
            }
        }
        
        CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, CFRunLoopMode.defaultMode)
        
        waitForExpectations(timeout: 4.0, handler: nil)
    }
    
   
    
    func pump() {
        RunLoop.current.limitDate(forMode: RunLoopMode.defaultRunLoopMode)
    }
    
    func harness(_ vc: UIViewController) {
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 320, height: 500))
        window.rootViewController = vc
        window.makeKeyAndVisible()
    }
}
