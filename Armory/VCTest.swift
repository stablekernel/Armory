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
     Selects the tab at the specified index from the given `UITabBar` instance

     - Note: The provided `UITabBar` instance must be managed by a `UITabBarController` otherwise we are not able to return the selected view controller.

     This method will crash with a fatalError if provided a `UITabBar` that is not managed by `UITabBarController`

     - parameter index: Index of the tab to be selected
     - parameter tabBar: `UITabBar` instance used for selection

     - returns: The view controller that is selected
     */
    func selectTab<A: UIViewController>(atIndex index: Int, fromTabBar tabBar: UITabBar) -> A

    /**
     Selects the tab with the specified title from the given `UITabBar` instance

     - Note: The provided `UITabBar` instance must be managed by a `UITabBarController` otherwise we are not able to return the selected view controller.

     This method will crash with a fatalError if provided a `UITabBar` that is not managed by `UITabBarController`

     - parameter title: Title of tab to be selected
     - parameter tabBar: `UITabBar` instance used for selection

     - returns: The view controller that is selected
     */
    func selectTab<A: UIViewController>(withTitle title: String, fromTabBar tabBar: UITabBar) -> A

    /**
     Selects the tab with the specified image from the given `UITabBar` instance

     - Note: The provided `UITabBar` instance must be managed by a `UITabBarController` otherwise we are not able to return the selected view controller.

     This method will crash with a fatalError if provided a `UITabBar` that is not managed by `UITabBarController`

     - parameter image: Image of tab to be selected
     - parameter tabBar: `UITabBar` instance used for selection

     - returns: The view controller that is selected
     */
    func selectTab<A: UIViewController>(withImage image: UIImage, fromTabBar tabBar: UITabBar) -> A

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

    func selectTab<A: UIViewController>(atIndex index: Int, fromTabBar tabBar: UITabBar) -> A {
        guard let controller = tabBar.delegate as? UITabBarController else {
            fatalError("Provided UITabBar must be managed by a UITabBarController" )
        }

        controller.selectedIndex = index
        pump()

        return controller.selectedViewController as! A

    }

    func selectTab<A: UIViewController>(withTitle title: String, fromTabBar tabBar: UITabBar) -> A {
        guard let index = tabBar.items?.enumerated().first(where: { $0.element.title == title })?.offset else {
            fatalError("Provided UITabBar does not have a UITabBarItem with the title: \(title)")
        }

        return selectTab(atIndex: index, fromTabBar: tabBar)
    }

    func selectTab<A: UIViewController>(withImage image: UIImage, fromTabBar tabBar: UITabBar) -> A {
        guard let index = tabBar.items?.enumerated().first(where: { $0.element.image == image })?.offset else {
            fatalError("Provided UITabBar does not have a UITabBarItem with the image: \(image)")
        }

        return selectTab(atIndex: index, fromTabBar: tabBar)
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
