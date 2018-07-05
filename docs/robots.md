# Robots

Robot classes are typed to a specific view controller, and provide app/domain-specific API around Armory. Robots are intended to be subclassed 1:1 for each view controller.

## Example

Let's say you have a `DatePickerViewController` in one of your view controllers, and want to test selecting the date across multiple tests. While Armory provides a `selectDate` method, you likely have other user interactions that are necessary to trigger your date selection workflow as well.  

Instead of writing out this setup code across multiple tests, create a `ViewControllerRobot` with a `selectDate` method to trigger this workflow in a single line of code in your test class.  

##### ViewControllerRobot.swift
```swift
class ViewControllerRobot: Robot<MyViewController> {

	func selectDate(_ date: Date, type: DateType, animated: Bool = true) {

		tap(viewController.dateTextInput)
		let datePickerVC: DatePickerViewController = waitForPresentedViewController()

		selectDate(date, fromDatePicker: datePickerVC.datePicker, animated: animated)

		let button: UIBarButtonItem

		switch type {
		case .scheduled:
			button = datePickerVC.scheduledButton
		case .estimated:
			button = datePickerVC.estimatedButton
		}

		tap(button)
		waitForDismissedViewController()
	}
}

```

##### ViewControllerTests.swift
```swift
class ViewControllerTests: XCTest, VCTest {
	var robot: ViewControllerRobot!
	
	override func setUp() {
		super.setUp()
		robot = ViewControllerRobot(self)
	}

	func testCanSetScheduledDate() {
		let date = Date()

		robot.selectDate(date, type: .scheduled)

		XCTAssertEqual(date, datePickerVC.datePicker.date)
	}

	func testCanSetEstimatedDate() {
		let date = Date()

		robot.selectDate(date, type: .estimated)

		XCTAssertEqual(date, datePickerVC.datePicker.date)
	}
}
```