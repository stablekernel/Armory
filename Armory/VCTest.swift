//
//  Armory.swift
//  Armory
//
//  Created by Joe Conway on 8/29/17.
//  Copyright © 2017 stablekernel. All rights reserved.
//

import Foundation
import XCTest

/**
 Errors that can be thrown when working with Armory methods
 */
enum ArmoryError: Error {
    
    case indexOutOfBounds
    case imageLookupFailed
    case titleLookupFailed
    case invalidCellType
    case invalidValue
    case multipleMatchesFound
}

// MARK: - ArmoryTestable

protocol ArmoryTestable: Armory {
    
    func build()
    
    func harness(_ vc: UIViewController)
}

// MARK: - Armory

/**
 Convenience typealias used internally to cast `UIAlertAction` handlers
 */
typealias AlertHandler = @convention(block) (UIAlertAction) -> Void

protocol Armory {
    
    associatedtype ViewControllerType: UIViewController
    
    var viewController: ViewControllerType! { get }
    
    // MARK: - Conveniences
    
    /**
     Convenience that waits for a given test to complete before continuing
     
     - Note: Fails if default timeout of 4s is exceeded
     */
    func after(_ test: @autoclosure @escaping () -> Bool)
    
    /**
     Convenience that performs one pass through the run loop for the current thread
     */
    func pump()

    /**
     The result of this function is used by `after` to handle testing asynchronous expectations

     Typically an `XCTestCase` will conform to `ArmoryTestable` and provide a convenient default implementation

     Documentation for the default implementation can be found in the `XCTestCase` class reference
     */
    func expectation(description: String) -> XCTestExpectation

    /**
     Used by `after` to wait for expectations expected to be fulfilled

     Typically an `XCTestCase` will conform to `ArmoryTestable` and provide a convenient default implementation

     Documentation for the default implementation can be found in the `XCTestCase` class reference
     */
    func waitForExpectations(timeout: TimeInterval, handler: XCWaitCompletionHandler?)
    
    /**
     Convenience that asserts a view controller is presented while subsequently returning it.
     
     - returns: The presented view controller
     */
    func waitForPresentedViewController<A: UIViewController>() -> A
    
    /**
     Convenience that asserts the presented view controller is dismissed
     */
    func waitForDismissedViewController()
    
    // MARK: - UIControl
    
    /**
     Sends a `touchUpInside` event to the given `UIControl`
     
     - parameter control: The `UIControl` to send event to
     */
    func tap(_ control: UIControl)
    
    /**
     Performs the action associated with a `UIBarButtonItem`
     
     - parameter barButtonItem: The `UIBarButtonItem` with action to perform
     */
    func tap(_ barButtonItem: UIBarButtonItem)
    
    /**
     Inserts given `text` into the `UITextField` one character at a time to simulate a user typing
     
     - parameter control: The `UITextField` to enter text into
     - parameter text: The text to type into the `textField`
     */
    func type(_ control: UITextField, text: String)
    
    // MARK: - UIAlertController
    
    /**
     Calls handler for `UIAlertAction` matching provided title in the given `UIAlertController` instance and dismisses alert
     
     - parameter title: Title for `UIAlertAction`
     - parameter alertController: The `UIAlertController` instance that contains the `UIAlertAction`
     
     - throws: ArmoryError.titleLookupFailed
     */
    func tapButton(withTitle title: String, fromAlertController alertController: UIAlertController) throws
    
    // MARK: - UICollectionView
    
    /**
     Returns cell of provided type from the given `UICollectionView` instance
     
     - parameter indexPath: The `IndexPath` for cell retrieval
     - parameter collectionView: The `UICollectionView` that contains the cell
     
     - throws: ArmoryError.invalidCellType
     
     - returns: The cell at the given `indexPath`
     */
    func cell<A: UICollectionViewCell>(at indexPath: IndexPath, fromCollectionView collectionView: UICollectionView) throws -> A
    
    // MARK: - UIDatePicker
    
    /**
     Calls the `setDate` method for the given `UIDatePicker` instance
     
     - parameter date: `Date` to be set in `UIDatePicker`
     - parameter datePicker: `UIDatePicker` instance to set date on
     - parameter animated: Default `true`. Set to `false` to disable animation of date selection.
     */
    func selectDate(_ date: Date, fromDatePicker datePicker: UIDatePicker, animated: Bool)
    
    // MARK: - UIPickerView
    
    /**
     Calls the `selectRow` method for given `UIPickerView` instance
     
     - parameter row: Item's row within `picker`
     - parameter picker: The `UIPickerView` where item is located
     - parameter animated: Default `true`. Set to `false` to disable animation of item selection.
     */
    func selectItem(atRow row: Int, fromPicker picker: UIPickerView, animated: Bool)
    
    // MARK: - UISegmentedControl
    
    /**
     Selects the segment at the specified index from the given `UISegmentedControl` instance
     
     - parameter index: Index of segment to be selected
     - parameter segmentedControl: `UISegmentedControl` instance used for selection
     
     - throws: `ArmoryError`
     */
    func selectSegment(atIndex index: Int, fromSegmentedControl segmentedControl: UISegmentedControl) throws
    
    /**
     Selects the segment with specified title from the given `UISegmentedControl` instance
     
     - parameter title: Title of segment to be selected
     - parameter segmentedControl: `UISegmentedControl` instance used for selection
     
     - throws: `ArmoryError`
     */
    func selectSegment(withTitle title: String, fromSegmentedControl segmentedControl: UISegmentedControl) throws
    
    /**
     Selects the segment with the specified image from the given `UISegmentedControl` instance
     
     - parameter image: Image of segment to selected
     - parameter segmentedControl: `UISegmentedControl` instance used for selection
     
     - throws: `ArmoryError`
     */
    func selectSegment(withImage image: UIImage, fromSegmentedControl segmentedControl: UISegmentedControl) throws
    
    // MARK: - UISlider
    
    /**
     Updates the provided `UISlider` instance with the given normalized value
     
     - parameter slider: The provided `UISlider` instance to update
     - parameter value: The normalized value to slide to. Valid values are between 0.0 and 1.0 inclusive.
     - parameter animated: Default `true`. Set to `false` to disable animation of sliding action.
     
     - throws: ArmoryError.invalidValue
     */
    func slide(_ slider: UISlider, toNormalizedValue value: Float, animated: Bool) throws
    
    // MARK: - UIStepper
    
    /**
     Increments `stepper` by default `stepValue`
     
     - parameter stepper: The `UIStepper` instance to be incremented
     */
    func increment(_ stepper: UIStepper)
    
    /**
     Decrements `stepper` by default `stepValue`
     
     - parameter stepper: The `UIStepper` instance to be decremented
     */
    func decrement(_ stepper: UIStepper)
    
    // MARK: - UISwitch
    
    /**
     Calls the `setOn` method of the given `UISwitch` instance
     
     - parameter aSwitch: `UISwitch` instance to toggle
     - parameter animated: Default `true`. Set to `false` to disable animation of `UISwitch` toggle.
     */
    func toggle(_ aSwitch: UISwitch, animated: Bool)
    
    // MARK: - UITabBar
    
    /**
     Selects the tab at the specified index from the given `UITabBar` instance
     
     - parameter index: Index of the tab to be selected
     - parameter tabBar: `UITabBar` instance used for selection
     
     - throws: ArmoryError.indexOutOfBounds
     */
    func selectTab(atIndex index: Int, fromTabBar tabBar: UITabBar) throws
    
    /**
     Selects the tab with the specified title from the given `UITabBar` instance
     
     - parameter title: Title of tab to be selected
     - parameter tabBar: `UITabBar` instance used for selection
     
     - throws: ArmoryError.titleLookupFailed
     */
    func selectTab(withTitle title: String, fromTabBar tabBar: UITabBar) throws
    
    /**
     Selects the tab with the specified image from the given `UITabBar` instance.
     
     - parameter image: Image of tab to be selected
     - parameter tabBar: `UITabBar` instance used for selection
     
     - throws: ArmoryError.imageLookupFailed
     */
    func selectTab(withImage image: UIImage, fromTabBar tabBar: UITabBar) throws
    
    // MARK: - UITabBarController
    
    /**
     Selects the tab at the specified index from the given `UITabBarController` instance
     
     - parameter index: Index of the tab to be selected
     - parameter tabBarController: `UITabBarController` instance used for selection
     
     - throws: ArmoryError.indexOutOfBounds
     
     - returns: The view controller that is selected
     */
    @discardableResult func selectTab<A: UIViewController>(atIndex index: Int, fromTabBarController tabBarController: UITabBarController) throws -> A
    
    /**
     Selects the tab with the specified title from the given `UITabBarController` instance
     
     - parameter title: Title of tab to be selected
     - parameter tabBarController: `UITabBarController` instance used for selection
     
     - throws: ArmoryError.titleLookupFailed
     
     - returns: The view controller that is selected
     */
    @discardableResult func selectTab<A: UIViewController>(withTitle title: String, fromTabBarController tabBarController: UITabBarController) throws -> A
    
    /**
     Selects the tab with the specified image from the given `UITabBarController` instance
     
     - parameter image: Image of tab to be selected
     - parameter tabBarController: `UITabBarController` instance used for selection
     
     - throws: ArmoryError.imageLookupFailed
     
     - returns: The view controller that is selected
     */
    @discardableResult func selectTab<A: UIViewController>(withImage image: UIImage, fromTabBarController tabBarController: UITabBarController) throws -> A
    
    // MARK: - UITableView Methods
    
    /**
     Returns cell of provided type from the given `UITableView` instance
     
     - parameter indexPath: The `IndexPath` for cell retrieval
     - parameter tableView: The `UITableView` that contains the cell
     
     - throws: ArmoryError.invalidCellType
     
     - returns: The cell at the given `indexPath`
     */
    func cell<A: UITableViewCell>(at indexPath: IndexPath, fromTableView tableView: UITableView) throws -> A
}

// MARK: - Armory Default Implementation

extension Armory {
    
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
    
    func waitForPresentedViewController<A: UIViewController>() -> A {
        after(self.viewController.presentedViewController != nil)
        return viewController.presentedViewController as! A
    }
    
    func waitForDismissedViewController() {
        after(self.viewController.presentedViewController == nil)
    }
    
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
    
    func tapButton(withTitle title: String, fromAlertController alertController: UIAlertController) throws {
        guard let action = alertController.actions.first(where: { $0.title == title }) else {
            throw ArmoryError.titleLookupFailed
        }
        
        guard action.isEnabled else {
            return
        }
        
        let actionHandler = action.value(forKey: "handler")
        let blockPtr = UnsafeRawPointer(Unmanaged<AnyObject>.passUnretained(actionHandler as AnyObject).toOpaque())
        let handler = unsafeBitCast(blockPtr, to: AlertHandler.self)
        
        handler(action)
        alertController.dismiss(animated: true, completion: nil)
        pump()
    }
    
    func cell<A: UICollectionViewCell>(at indexPath: IndexPath, fromCollectionView collectionView: UICollectionView) throws -> A {
        let cell = collectionView.cellForItem(at: indexPath)
        
        guard let validCell = cell as? A else {
            throw ArmoryError.invalidCellType
        }
        
        return validCell
    }
    
    func selectDate(_ date: Date, fromDatePicker datePicker: UIDatePicker, animated: Bool = true) {
        datePicker.setDate(date, animated: animated)
        pump()
    }
    
    func selectItem(atRow row: Int, fromPicker picker: UIPickerView, animated: Bool = true) {
        picker.selectRow(row, inComponent: 0, animated: animated)
        pump()
    }
    
    func selectSegment(atIndex index: Int, fromSegmentedControl segmentedControl: UISegmentedControl) throws {
        guard isTappable(segmentedControl) && segmentedControl.selectedSegmentIndex != index else {
            return
        }
        
        guard index >= 0 && index < segmentedControl.numberOfSegments else {
            throw ArmoryError.indexOutOfBounds
        }
        
        segmentedControl.selectedSegmentIndex = index
        segmentedControl.sendActions(for: .valueChanged)
        pump()
    }
    
    func selectSegment(withTitle title: String, fromSegmentedControl segmentedControl: UISegmentedControl) throws {
        let filteredItems = (0..<segmentedControl.numberOfSegments).filter { segmentedControl.titleForSegment(at: $0) == title }
        
        guard !filteredItems.isEmpty else {
            throw ArmoryError.titleLookupFailed
        }
        
        guard filteredItems.count == 1 else {
            throw ArmoryError.multipleMatchesFound
        }
        
        let index = filteredItems[0]
        
        try selectSegment(atIndex: index, fromSegmentedControl: segmentedControl)
    }
    
    func selectSegment(withImage image: UIImage, fromSegmentedControl segmentedControl: UISegmentedControl) throws {
        let filteredItems = (0..<segmentedControl.numberOfSegments).filter { segmentedControl.imageForSegment(at: $0)?.isEqual(image) == true }
        
        guard !filteredItems.isEmpty else {
            throw ArmoryError.imageLookupFailed
        }
        
        guard filteredItems.count == 1 else {
            throw ArmoryError.multipleMatchesFound
        }
        
        let index = filteredItems[0]
        
        try selectSegment(atIndex: index, fromSegmentedControl: segmentedControl)
    }
    
    func slide(_ slider: UISlider, toNormalizedValue value: Float, animated: Bool = true) throws {
        guard isTappable(slider) else {
            return
        }
        
        guard value >= 0 && value <= 1 else {
            throw ArmoryError.invalidValue
        }
        
        let cleanValue = value > 0 ? min(value, 1) : max(value, 0)
        let distance = slider.maximumValue - slider.minimumValue
        let displayValue = (cleanValue * distance) + slider.minimumValue
        
        guard slider.value != displayValue else {
            return
        }
        
        slider.setValue(displayValue, animated: animated)
        slider.sendActions(for: .valueChanged)
        pump()
    }
    
    func increment(_ stepper: UIStepper) {
        guard isTappable(stepper) && stepper.value < stepper.maximumValue else {
            return
        }
        
        stepper.value += stepper.stepValue
        stepper.sendActions(for: .valueChanged)
        pump()
    }
    
    func decrement(_ stepper: UIStepper) {
        guard isTappable(stepper) && stepper.value > stepper.minimumValue else {
            return
        }
        
        stepper.value -= stepper.stepValue
        stepper.sendActions(for: .valueChanged)
        pump()
    }
    
    func toggle(_ aSwitch: UISwitch, animated: Bool = true) {
        guard isTappable(aSwitch) else {
            return
        }
        
        aSwitch.setOn(!aSwitch.isOn, animated: animated)
        aSwitch.sendActions(for: .valueChanged)
        pump()
    }
    
    @discardableResult func selectTab<A: UIViewController>(atIndex index: Int, fromTabBarController tabBarController: UITabBarController) throws -> A  {
        guard let items = tabBarController.tabBar.items,
            index >= 0 && index < items.count else {
                throw ArmoryError.indexOutOfBounds
        }
        
        tabBarController.selectedIndex = index
        pump()
        
        return tabBarController.selectedViewController as! A
    }
    
    @discardableResult func selectTab<A: UIViewController>(withTitle title: String, fromTabBarController tabBarController: UITabBarController) throws -> A {
        let filteredItems = tabBarController.tabBar.items!.enumerated().filter{ $0.element.title == title }
        
        guard !filteredItems.isEmpty else {
            throw ArmoryError.titleLookupFailed
        }
        
        guard filteredItems.count == 1 else {
            throw ArmoryError.multipleMatchesFound
        }
        
        let index = filteredItems[0].offset
        
        return try selectTab(atIndex: index, fromTabBarController: tabBarController)
    }
    
    @discardableResult func selectTab<A: UIViewController>(withImage image: UIImage, fromTabBarController tabBarController: UITabBarController) throws -> A {
        let filteredItems = tabBarController.tabBar.items!.enumerated().filter{ $0.element.image?.isEqual(image) == true }
        
        guard !filteredItems.isEmpty else {
            throw ArmoryError.imageLookupFailed
        }
        
        guard filteredItems.count == 1 else {
            throw ArmoryError.multipleMatchesFound
        }
        
        let index = filteredItems[0].offset
        
        return try selectTab(atIndex: index, fromTabBarController: tabBarController)
    }
    
    func selectTab(atIndex index: Int, fromTabBar tabBar: UITabBar) throws {
        guard let items = tabBar.items,
            index >= 0 && index < items.count else {
                throw ArmoryError.indexOutOfBounds
        }
        
        tabBar.selectedItem = items[index]
        pump()
    }
    
    func selectTab(withTitle title: String, fromTabBar tabBar: UITabBar) throws {
        let filteredItems = tabBar.items!.enumerated().filter{ $0.element.title == title }
        
        guard !filteredItems.isEmpty else {
            throw ArmoryError.titleLookupFailed
        }
        
        guard filteredItems.count == 1 else {
            throw ArmoryError.multipleMatchesFound
        }
        
        let index = filteredItems[0].offset
        
        try selectTab(atIndex: index, fromTabBar: tabBar)
    }
    
    func selectTab(withImage image: UIImage, fromTabBar tabBar: UITabBar) throws {
        let filteredItems = tabBar.items!.enumerated().filter{ $0.element.image?.isEqual(image) == true }
        
        guard !filteredItems.isEmpty else {
            throw ArmoryError.imageLookupFailed
        }
        
        guard filteredItems.count == 1 else {
            throw ArmoryError.multipleMatchesFound
        }
        
        let index = filteredItems[0].offset
        
        try selectTab(atIndex: index, fromTabBar: tabBar)
    }
    
    func cell<A: UITableViewCell>(at indexPath: IndexPath, fromTableView tableView: UITableView) throws -> A {
        let cell = tableView.cellForRow(at: indexPath)
        
        guard let validCell = cell as? A else {
            throw ArmoryError.invalidCellType
        }
        
        return validCell
    }
}

// MARK: - Private

extension Armory {
    
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

// MARK: - ArmoryTestable

extension ArmoryTestable {
    
    func harness(_ vc: UIViewController) {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = vc
        window.makeKeyAndVisible()
    }
    
    func build() {
        harness(viewController)
        pump()
    }
    
}
