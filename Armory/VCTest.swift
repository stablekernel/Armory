//
//  VCTest.swift
//  Armory
//
//  Created by Joe Conway on 8/29/17.
//  Copyright © 2017 stablekernel. All rights reserved.
//

import Foundation
import XCTest

enum ArmoryError: Error {
    
    case indexOutOfBounds
    case imageLookupFailed
    case titleLookupFailed
    case invalidCellType
    
}

// MARK: - VCTestSetup

protocol VCTestSetup: VCTest {

    func build()

    func harness(_ vc: UIViewController)
}

// MARK: - VCTest

typealias AlertHandler = @convention(block) (UIAlertAction) -> Void

protocol VCTest {
    
    associatedtype ViewControllerType: UIViewController

    var viewController: ViewControllerType! { get }

    func tap(_ control: UIControl)

    func tap(_ barButtonItem: UIBarButtonItem)
    
    /**
     Calls handler for `UIAlertAction` matching provided title in the given `UIAlertController` instance and dismisses alert
     
     - parameter title: Title for `UIAlertAction`
     - parameter alertController: The `UIAlertController` instance that contains the `UIAlertAction`
     
     - throws: ArmoryError.titleLookupFailed
     */
    func tapButton(withTitle title: String, fromAlertController alertController: UIAlertController) throws
    
    func type(_ control: UITextField, text: String)

    /**
     Convenience that asserts a view controller is presented while subsequently returning it.

     - returns: The presented view controller
     */
    func waitForPresentedViewController<A: UIViewController>() -> A

    /**
     Convenience that asserts the presented view controller is dismissed
     */
    func waitForDismissedViewController()
    
    /**
     Calls the `setDate` method for the given `UIDatePicker` instance
     
     - parameter date: `Date` to be set in `UIDatePicker`
     - parameter datePicker: `UIDatePicker` instance to set date on
     - parameter animated: Default `true`. Set to `false` to disable animation of date selection.
    */
    func selectDate(_ date: Date, fromDatePicker datePicker: UIDatePicker, animated: Bool)
    
    /**
     Calls the `selectRow` method for given `UIPickerView` instance
     
     - parameter row: Item's row within `picker`
     - parameter picker: The `UIPickerView` where item is located
     - paramater animated: Default `true`. Set to `false` to disable animation of item selection.
     */
    func selectItem(atRow row: Int, fromPicker picker: UIPickerView, animated: Bool)
    
    /**
     Returns cell of provided type from the given `UITableView` instance
     
     - parameter indexPath: The `IndexPath` for cell retrieval
     - parameter tableView: The `UITableView` that contains the cell
     
     - throws: ArmoryError.invalidCellType
     
     - returns: The cell at the given `indexPath`
     */
    func cell<A: UITableViewCell>(at indexPath: IndexPath, fromTableView tableView: UITableView) throws -> A
    
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
    
    func tapButton(withTitle title: String, fromAlertController alertController: UIAlertController) throws {
        guard let action = alertController.actions.first(where: { $0.title == title }) else {
            throw ArmoryError.titleLookupFailed
        }
        
        guard action.isEnabled else {
            return
        }
        
        let actionhandler = action.value(forKey: "handler")
        let blockPtr = UnsafeRawPointer(Unmanaged<AnyObject>.passUnretained(actionhandler as AnyObject).toOpaque())
        let handler = unsafeBitCast(blockPtr, to: AlertHandler.self)
        
        handler(action)
        alertController.dismiss(animated: true, completion: nil)
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

    func waitForPresentedViewController<A: UIViewController>() -> A {
        after(self.viewController.presentedViewController != nil)
        return viewController.presentedViewController as! A
    }

    func waitForDismissedViewController() {
        after(self.viewController.presentedViewController == nil)
    }

    func selectDate(_ date: Date, fromDatePicker datePicker: UIDatePicker, animated: Bool = true) {
        datePicker.setDate(date, animated: animated)
        pump()
    }

    func selectItem(atRow row: Int, fromPicker picker: UIPickerView, animated: Bool = true) {
        picker.selectRow(row, inComponent: 0, animated: animated)
        pump()
    }
    
    func cell<A: UITableViewCell>(at indexPath: IndexPath, fromTableView tableView: UITableView) throws -> A {
        let cell = tableView.cellForRow(at: indexPath)
        
        guard let validCell = cell as? A else {
            throw ArmoryError.invalidCellType
        }
        
        return validCell
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
        // Disabled controls do not receive touch events
        // Since we are programmatically hit testing, we need to confirm the control is enabled
        return control.isEnabled && control.superview?.hitTest(control.center, with: nil) != nil
    }
}
