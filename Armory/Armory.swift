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
    case cellNotEditable
}

// MARK: - Armory

/**
 Convenience typealias used internally to cast `UIAlertAction` handlers
 */
typealias AlertHandler = @convention(block) (UIAlertAction) -> Void

typealias TableViewCellHandler = @convention(block) (UITableViewRowAction, IndexPath) -> Void

protocol Armory {

    associatedtype ViewControllerType: UIViewController

    /**
     The specific type of view controller being tested
     */
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

     - Parameters:
     - control: The `UIControl` to send event to
     */
    func tap(_ control: UIControl)

    /**
     Performs the action associated with a `UIBarButtonItem`

     - Parameters:
     - barButtonItem: The `UIBarButtonItem` with action to perform
     */
    func tap(_ barButtonItem: UIBarButtonItem)

    /**
     Inserts given `text` into the `UITextField` one character at a time to simulate a user typing

     - Parameters:
     - control: The `UITextField` to enter text into
     - text: The text to type into the `textField`
     */
    func type(_ control: UITextField, text: String)

    // MARK: - UIAlertController

    /**
     Calls handler for `UIAlertAction` matching provided title in the given `UIAlertController` instance and dismisses alert

     - Parameters:
     - title: Title for `UIAlertAction`
     - alertController: The `UIAlertController` instance that contains the `UIAlertAction`

     - throws: ArmoryError.titleLookupFailed
     */
    func tapButton(withTitle title: String, fromAlertController alertController: UIAlertController) throws

    // MARK: - UICollectionView

    /**
     Returns cell of provided type from the given `UICollectionView` instance

     - Parameters:
     - indexPath: The `IndexPath` for cell retrieval
     - collectionView: The `UICollectionView` that contains the cell

     - throws: ArmoryError.invalidCellType

     - returns: The cell at the given `indexPath`
     */
    func cell<A: UICollectionViewCell>(at indexPath: IndexPath, fromCollectionView collectionView: UICollectionView) throws -> A

    // MARK: - UIDatePicker

    /**
     Calls the `setDate` method for the given `UIDatePicker` instance

     - Parameters:
     - date: `Date` to be set in `UIDatePicker`
     - datePicker: `UIDatePicker` instance to set date on
     - animated: Default `true`. Set to `false` to disable animation of date selection.
     */
    func selectDate(_ date: Date, fromDatePicker datePicker: UIDatePicker, animated: Bool)

    // MARK: - UIPickerView

    /**
     Calls the `selectRow` method for given `UIPickerView` instance

     - Parameters:
     - row: Item's row within `picker`
     - picker: The `UIPickerView` where item is located
     - animated: Default `true`. Set to `false` to disable animation of item selection.
     */
    func selectItem(atRow row: Int, fromPicker picker: UIPickerView, animated: Bool)

    // MARK: - UISegmentedControl

    /**
     Selects the segment at the specified index from the given `UISegmentedControl` instance

     - Parameters:
     - index: Index of segment to be selected
     - segmentedControl: `UISegmentedControl` instance used for selection

     - throws: `ArmoryError`
     */
    func selectSegment(atIndex index: Int, fromSegmentedControl segmentedControl: UISegmentedControl) throws

    /**
     Selects the segment with specified title from the given `UISegmentedControl` instance

     - Parameters:
     - title: Title of segment to be selected
     - segmentedControl: `UISegmentedControl` instance used for selection

     - throws: `ArmoryError`
     */
    func selectSegment(withTitle title: String, fromSegmentedControl segmentedControl: UISegmentedControl) throws

    /**
     Selects the segment with the specified image from the given `UISegmentedControl` instance

     - Parameters:
     - image: Image of segment to selected
     - segmentedControl: `UISegmentedControl` instance used for selection

     - throws: `ArmoryError`
     */
    func selectSegment(withImage image: UIImage, fromSegmentedControl segmentedControl: UISegmentedControl) throws

    // MARK: - UISlider

    /**
     Updates the provided `UISlider` instance with the given normalized value

     - Parameters:
     - slider: The provided `UISlider` instance to update
     - value: The normalized value to slide to. Valid values are between 0.0 and 1.0 inclusive.
     - animated: Default `true`. Set to `false` to disable animation of sliding action.

     - throws: ArmoryError.invalidValue
     */
    func slide(_ slider: UISlider, toNormalizedValue value: Float, animated: Bool) throws

    // MARK: - UIStepper

    /**
     Increments `stepper` by default `stepValue`

     - Parameters:
     - stepper: The `UIStepper` instance to be incremented
     */
    func increment(_ stepper: UIStepper)

    /**
     Decrements `stepper` by default `stepValue`

     - Parameters:
     - stepper: The `UIStepper` instance to be decremented
     */
    func decrement(_ stepper: UIStepper)

    // MARK: - UISwitch

    /**
     Calls the `setOn` method of the given `UISwitch` instance

     - Parameters:
     - aSwitch: `UISwitch` instance to toggle
     - animated: Default `true`. Set to `false` to disable animation of `UISwitch` toggle.
     */
    func toggle(_ aSwitch: UISwitch, animated: Bool)

    // MARK: - UITabBar

    /**
     Selects the tab at the specified index from the given `UITabBar` instance

     - Parameters:
     - index: Index of the tab to be selected
     - tabBar: `UITabBar` instance used for selection

     - throws: ArmoryError.indexOutOfBounds
     */
    func selectTab(atIndex index: Int, fromTabBar tabBar: UITabBar) throws

    /**
     Selects the tab with the specified title from the given `UITabBar` instance

     - Parameters:
     - title: Title of tab to be selected
     - tabBar: `UITabBar` instance used for selection

     - throws: ArmoryError.titleLookupFailed
     */
    func selectTab(withTitle title: String, fromTabBar tabBar: UITabBar) throws

    /**
     Selects the tab with the specified image from the given `UITabBar` instance.

     - Parameters:
     - image: Image of tab to be selected
     - tabBar: `UITabBar` instance used for selection

     - throws: ArmoryError.imageLookupFailed
     */
    func selectTab(withImage image: UIImage, fromTabBar tabBar: UITabBar) throws

    // MARK: - UITabBarController

    /**
     Selects the tab at the specified index from the given `UITabBarController` instance

     - Parameters:
     - index: Index of the tab to be selected
     - tabBarController: `UITabBarController` instance used for selection

     - throws: ArmoryError.indexOutOfBounds

     - returns: The view controller that is selected
     */
    @discardableResult func selectTab<A: UIViewController>(atIndex index: Int, fromTabBarController tabBarController: UITabBarController) throws -> A

    /**
     Selects the tab with the specified title from the given `UITabBarController` instance

     - Parameters:
     - title: Title of tab to be selected
     - tabBarController: `UITabBarController` instance used for selection

     - throws: ArmoryError.titleLookupFailed

     - returns: The view controller that is selected
     */
    @discardableResult func selectTab<A: UIViewController>(withTitle title: String, fromTabBarController tabBarController: UITabBarController) throws -> A

    /**
     Selects the tab with the specified image from the given `UITabBarController` instance

     - Parameters:
     - image: Image of tab to be selected
     - tabBarController: `UITabBarController` instance used for selection

     - throws: ArmoryError.imageLookupFailed

     - returns: The view controller that is selected
     */
    @discardableResult func selectTab<A: UIViewController>(withImage image: UIImage, fromTabBarController tabBarController: UITabBarController) throws -> A

    // MARK: - UITableView Methods

    /**
     Returns cell of provided type from the given `UITableView` instance

     - Parameters:
     - indexPath: The `IndexPath` for cell retrieval
     - tableView: The `UITableView` that contains the cell

     - throws: ArmoryError.invalidCellType

     - returns: The cell at the given `indexPath`
     */
    func cell<A: UITableViewCell>(at indexPath: IndexPath, fromTableView tableView: UITableView) throws -> A

    /**
     Calls handler for `UITableViewRowAction` provided at the given `IndexPath`
     
     - Parameters:
     - action: The `UITableViewRowAction` to call handler for
     - indexPath: `IndexPath` of `UITableViewCell` that contains action
     - tableView: The `UITableView` instance where row is located
     
     - throws: ArmoryError
     */
    func selectCellAction(withTitle title: String, at indexPath: IndexPath, in tableView: UITableView) throws

    /**
     Selects the row at `indexPath` in given `UITableView`

     - Parameters:
     - indexPath: The `IndexPath` of row to select
     - tableView: The `UITableView` instance where row is located
     */
    func selectRow(at indexPath: IndexPath, fromTableView tableView: UITableView)
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

        guard barButtonItem.isEnabled else {
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

        let distance = slider.maximumValue - slider.minimumValue
        let displayValue = (value * distance) + slider.minimumValue

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

    func selectCellAction(withTitle title: String, at indexPath: IndexPath, in tableView: UITableView) throws {
        let action: UITableViewRowAction

        do {
            action = try retrieveActionForCell(withTitle: title, at: indexPath, in: tableView)
        } catch {
            throw error
        }

        let actionHandler = action.value(forKey: "handler")
        let blockPtr = UnsafeRawPointer(Unmanaged<AnyObject>.passUnretained(actionHandler as AnyObject).toOpaque())
        let handler = unsafeBitCast(blockPtr, to: TableViewCellHandler.self)
        
        handler(action, indexPath)
        pump()
    }

    func selectRow(at indexPath: IndexPath, fromTableView tableView: UITableView) {
        tableView.delegate!.tableView!(tableView, didSelectRowAt: indexPath)
    }
}

// MARK: - Private

extension Armory {

    /**
     Returns whether UIControl is able to be tapped.

     - Parameters:
     - control: checked for ability to be tapped
     */
    fileprivate func isTappable(_ control: UIControl) -> Bool {
        // Disabled controls do not receive touch events
        // Since we are programmatically hit testing, we need to confirm the control is enabled
        return control.isEnabled && control.superview?.hitTest(control.center, with: nil) != nil
    }

    /**
     Returns `UITableViewRowAction` with specified title for the `UITableViewCell` at given `IndexPath` in `UITableView`

     - parameter title: Title of edit action to be retrieved
     - parameter indexPath: `IndexPath` of `UITableViewCell` that contains action
     - parameter tableView: `UITableView` instance where `UITableViewCell` is located

     - throws: ArmoryError
     */
    fileprivate func retrieveActionForCell(withTitle title: String, at indexPath: IndexPath, in tableView: UITableView) throws -> UITableViewRowAction {

        guard let actions = tableView.delegate!.tableView!(tableView, editActionsForRowAt: indexPath) else {
            throw ArmoryError.cellNotEditable
        }

        let filteredActions = actions.filter { $0.title == title }

        guard !filteredActions.isEmpty else {
            throw ArmoryError.titleLookupFailed
        }

        guard filteredActions.count == 1 else {
            throw ArmoryError.multipleMatchesFound
        }

        return filteredActions[0]
    }
}

// MARK: - ArmoryTestable

protocol ArmoryTestable: Armory {

    /**
     Called at the end of a test's `setUp` method after initializing the `viewController` in order to generate a new `UIWindow` for your test
     */
    func build()

    /**
     Creates a new `UIWindow` the size of the device's `UIScreen` and sets the `viewController` as the window's `rootViewController`

     - Parameters:
     - vc: The `viewController` to set as the new window's `rootViewController`

     - Note: You should not call this method directly. Instead, call `build` and it will call this method and `pump` to setup the initial test window.
     */
    func harness(_ vc: UIViewController)
}

// MARK: - ArmoryTestable Default Implementation

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
