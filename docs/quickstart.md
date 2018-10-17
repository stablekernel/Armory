# Quickstart

Armory is built to run along side existing XCTests in your project.

To get started, first make sure your test class conforms to the `ArmoryTestable` protocol:

```swift
class MyViewControllerTests: XCTestCase, ArmoryTestable
```

```
override func setUp() {
    viewController = // Instantiate VC programmatically, from xib or from storyboard
    build()
}

override func tearDown() {
    viewController = nil
}

```

Then use provided Armory methods in any place where you would like to simulate user interaction. For example, a `UITextField` that you want to enter text into would look like:

```swift
type(viewController.myTextField, text: "Some text here")
```

The process is similar for other elements, so if you wanted to tap a button you would write:

```swift
tap(myButton)
```

In addition to interacting with `UIKit` elements, Armory also provides conveniences for testing `UIViewController` presentations and dismissals. Below shows an example of how to test presenting and dismissing a `UIAlertController` instance:

```swift
tap(viewController.showAlertButton)

let alertController: UIAlertController = waitForPresentedViewController()
tapButton(withTitle: "Close", fromAlertController: alertController)

waitForDismissedViewController()
XCTAssertNil(viewController.presentedViewController)
```
