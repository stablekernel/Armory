//
//  VCTest.swift
//  Armory
//
//  Created by Joe Conway on 8/29/17.
//  Copyright © 2017 stablekernel. All rights reserved.
//

import Foundation
import XCTest

// MARK: - VCTestSetup

protocol VCTestSetup: VCTest {

    func build()

    func harness(_ vc: UIViewController)
}

// MARK: - VCTest

protocol VCTest {
    associatedtype ViewControllerType: UIViewController

    var viewController: ViewControllerType! { get }

    func tap(_ control: UIControl)

    func tap(_ barButtonItem: UIBarButtonItem)
    
    func type(_ control: UITextField, text: String)

    func waitForPresentedViewController<A: UIViewController>() -> A

    func waitForDismissedViewController()

    func selectDate(_ date: Date, fromDatePicker datePicker: UIDatePicker, animated: Bool)

    func selectItem(atRow row: Int, fromPicker picker: UIPickerView, animated: Bool)

    func after(_ test: @autoclosure @escaping () -> Bool)

    func pump()

    func expectation(description: String) -> XCTestExpectation

    func waitForExpectations(timeout: TimeInterval, handler: XCWaitCompletionHandler?)
}

// MARK: - VCTest Default Implementation

extension VCTest {

    func tap(_ control: UIControl) {
        guard isTappable(control) else {
            return
        }

        control.sendActions(for: .touchUpInside)
        pump()
    }

    func tap(_ barButtonItem: UIBarButtonItem) {
        guard let target = barButtonItem.target,
            let action = barButtonItem.action else {
                return
        }

        let _ = target.perform(action, with: barButtonItem)
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

    /**
     Convenience that asserts a view controller is presented while subsequently returning it.

     - returns: The presented view controller
     */
    func waitForPresentedViewController<A: UIViewController>() -> A {
        after(self.viewController.presentedViewController != nil)
        return viewController.presentedViewController as! A
    }

    /**
     Convenience that asserts the presented view controller is dismissed
     */
    func waitForDismissedViewController() {
        after(self.viewController.presentedViewController == nil)
    }

    func selectDate(_ date: Date, fromDatePicker datePicker: UIDatePicker, animated: Bool) {
        datePicker.setDate(date, animated: animated)
        pump()
    }

    func selectItem(atRow row: Int, fromPicker picker: UIPickerView, animated: Bool) {
        picker.selectRow(row, inComponent: 0, animated: false)
        pump()
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

    func build() {
        harness(viewController)
        pump()
    }
}

// MARK: - Private

extension VCTest {

    /**
     Returns whether UIControl is able to be tapped.

     - parameter control: checked for ability to be tapped
     */
    fileprivate func isTappable(_ control: UIControl) -> Bool {
        return control.superview?.hitTest(control.center, with: nil) == control
    }
}
