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
    case invalidValue
    case multipleMatchesFound
    case cellNotEditable
}

// MARK: - VCTestSetup

protocol VCTestSetup: VCTest {

    func build()

    func harness(_ vc: UIViewController)
}

// MARK: - VCTest

typealias AlertHandler = @convention(block) (UIAlertAction) -> Void

typealias TableViewCellHandler = @convention(block) (UITableViewRowAction, IndexPath) -> Void

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
     - parameter animated: Default `true`. Set to `false` to disable animation of item selection.
     */
    func selectItem(atRow row: Int, fromPicker picker: UIPickerView, animated: Bool)
    
    /**
     Calls the `setOn` method of the given `UISwitch` instance
     
     - parameter aSwitch: `UISwitch` instance to toggle
     - parameter animated: Default `true`. Set to `false` to disable animation of `UISwitch` toggle.
    */
    func toggle(_ aSwitch: UISwitch, animated: Bool)
    
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
    
    /**
     Returns cell of provided type from the given `UICollectionView` instance
     
     - parameter indexPath: The `IndexPath` for cell retrieval
     - parameter collectionView: The `UICollectionView` that contains the cell
     
     - throws: ArmoryError.invalidCellType
     
     - returns: The cell at the given `indexPath`
     */
    func cell<A: UICollectionViewCell>(at indexPath: IndexPath, fromCollectionView collectionView: UICollectionView) throws -> A

    /**
     Returns cell of provided type from the given `UITableView` instance
     
     - parameter indexPath: The `IndexPath` for cell retrieval
     - parameter tableView: The `UITableView` that contains the cell
     
     - throws: ArmoryError.invalidCellType
     
     - returns: The cell at the given `indexPath`
     */
    func cell<A: UITableViewCell>(at indexPath: IndexPath, fromTableView tableView: UITableView) throws -> A
    
    /**     
     Updates the provided `UISlider` instance with the given normalized value
     
     - parameter slider: The provided `UISlider` instance to update
     - parameter value: The normalized value to slide to. Valid values are between 0.0 and 1.0 inclusive.
     - parameter animated: Default `true`. Set to `false` to disable animation of sliding action.

     - throws: ArmoryError.invalidValue
    */
    func slide(_ slider: UISlider, toNormalizedValue value: Float, animated: Bool) throws

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
    
    /**
     Calls handler for `UITableViewRowAction` with given title in provided `UITableView`
     
     - parameter title: Title of edit action to be retrieved
     - parameter indexPath: `IndexPath` of `UITableViewCell` that contains action
     - parameter tableView: `UITableView` instance where `UITableViewCell` is located
     
     - throws: ArmoryError
    */
    func selectCellAction(withTitle title: String, at indexPath: IndexPath, in tableView: UITableView) throws

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
        
        let actionHandler = action.value(forKey: "handler")
        let blockPtr = UnsafeRawPointer(Unmanaged<AnyObject>.passUnretained(actionHandler as AnyObject).toOpaque())
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
    
    func toggle(_ aSwitch: UISwitch, animated: Bool = true) {
        guard isTappable(aSwitch) else {
            return
        }
        
        aSwitch.setOn(!aSwitch.isOn, animated: animated)
        aSwitch.sendActions(for: .valueChanged)
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

    func cell<A: UICollectionViewCell>(at indexPath: IndexPath, fromCollectionView collectionView: UICollectionView) throws -> A {
        let cell = collectionView.cellForItem(at: indexPath)
        
        guard let validCell = cell as? A else {
            throw ArmoryError.invalidCellType
        }
        
        return validCell
    }

    func cell<A: UITableViewCell>(at indexPath: IndexPath, fromTableView tableView: UITableView) throws -> A {
        let cell = tableView.cellForRow(at: indexPath)
        
        guard let validCell = cell as? A else {
            throw ArmoryError.invalidCellType
        }
        
        return validCell
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
