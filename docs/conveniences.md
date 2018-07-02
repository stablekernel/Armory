# Conveniences

### waitForPresentedViewController

Convenience that asserts a view controller is presented while subsequently returning it

```swift
func waitForPresentedViewController<A: UIViewController>() -> A
```

__Example__

```swift
tap(viewController.showAlert)

let alertController: UIAlertController = waitForPresentedViewController()
tapButton(withTitle: "Close", fromAlertController: alertController)

waitForDismissedViewController()
XCTAssertNil(viewController.presentedViewController)
```

___

### waitForDismissedViewController

Convenience that asserts the presented view controller is dismissed

```swift
func waitForDismissedViewController()
```

__Example__

```swift
tap(viewController.showAlert)

let alertController: UIAlertController = waitForPresentedViewController()
tapButton(withTitle: "Close", fromAlertController: alertController)

waitForDismissedViewController()
XCTAssertNil(viewController.presentedViewController)
```

___

### tap

```swift
func tap(_ control: UIControl)

func tap(_ barButtonItem: UIBarButtonItem)

func type(_ control: UIControl & UIKeyInput, text: String)
```
___

### after

Convenience that waits for given test to complete before continuing. Fails if default timeout of 4s is exceeded. 

```swift
func after(_ test: @autoclosure @escaping () -> Bool)
```

___

### pump

Convenience that performs one pass through the run loop for the current thread

```swift
func pump()
```

___