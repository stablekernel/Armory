### UIAlertController

Calls handler associated with specified `UIAlertAction` in a given `UIAlertController` instance and dismisses `UIAlertController`

```swift
func tapButton(withTitle title: String, fromAlertController alertController: UIAlertController)
```

__Parameters__

`title`: Title for `UIAlertAction`  
`alertController`: The `UIAlertController` instance that contains the `UIAlertAction`

__Example__

```swift
tap(viewController.showAlert)

let alertController: UIAlertController = waitForPresentedViewController()
tapButton(withTitle: "Close", fromAlertController: alertController)

waitForDismissedViewController()
XCTAssertNil(viewController.presentedViewController)
```

___
### UICollectionView

Returns typed cell from given `indexPath` in a `UICollectionView` instance

```swift
func selectCell<A: UICollectionViewCell>(atIndex indexPath: IndexPath, fromCollectionView collectionView: UICollectionView) -> A
```

__Parameters__

`indexPath`: `IndexPath` where the `UICollectionViewCell` is located  
`collectionView`: The `UICollectionView` that contains the cell

`returns`: The typed cell at given `indexPath`

__Example__

```swift
for row in 0..<viewController.myCollectionView.numberOfItems(inSection: 0) {
    let index = IndexPath(row: row, section: 0)
    scroll(to: index, in: viewController.myCollectionView)
    
    let cell: MyCollectionViewCell = selectCell(atIndex: index, fromCollectionView: viewController.myCollectionView)
    tap(cell.checkmarkButton)
}
```

___
### UITableView

Returns typed cell from given `indexPath` in a `UITableView` instance

```swift
func selectCell<A: UITableViewCell>(atIndex indexPath: IndexPath, fromTableView tableView: UITableView) -> A
```

__Parameters__

`indexPath`: `IndexPath` where the `UITableViewCell` is located  
`tableView`: The `UITableView` that contains the cell

`returns`: The typed cell at given `indexPath`

__Example__

```swift
for row in 0..<viewController.myTableView.numberOfRows(inSection: 0) {
    let index = IndexPath(row: row, section: 0)
    scroll(to: index, in: viewController.myTableView)
    
    let cell: MyTableViewCell = selectCell(atIndex: index, fromTableView: viewController.myTableView)
    tap(cell.checkmarkButton)
}
```

___
### UIDatePicker

Sets the date for a given `UIDatePicker` instance

```swift
func selectDate(_ date: Date, fromDatePicker datePicker: UIDatePicker, animated: Bool)
```

__Parameters__

`date`: `Date` to be set in `UIDatePicker`  
`datePicker`: `UIDatePicker` instance to set date on  
`animated`: Default `true`. Set to `false` to disable animation of date selection.

__Example__

```swift
tap(viewController.dateTextInput)
let datePickerVC: DatePickerViewController = waitForPresentedViewController()

selectDate(date, fromDatePicker: datePickerVC.datePicker, animated: animated)

XCTAssertEqual(date, datePickerVC.datePicker.date)
```

___
### UIPickerView

Selects item at row for a given `UIDatePicker` instance

```swift
func selectItem(atRow row: Int, fromPicker picker: UIPickerView, animated: Bool)
```

__Parameters__

`row`: Item's row within `picker`
`picker`: The `UIPickerView` where item is located
`animated`: Default `true`. Set to `false` to disable animation of item selection.

__Example__

```swift
selectItem(atRow: 1, fromPicker: viewController.pickerView, animated: true)
        
XCTAssertEqual(viewController.pickerView.selectedRow(inComponent: 0), 1)
```

___
### UISegmentedControl

Selects the segment at index of given `UISegmentedControl`

```swift
func selectSegment(_ segmentedControl: UISegmentedControl, atIndex index: Int)
```

__Parameters__

`segmentedControl`: `UISegmentedControl` instance to update  
`index`: Index of segment to be selected

__Example__

```swift
let index = 1
        
selectSegment(viewController.segmentedControl, atIndex: index)

XCTAssertEqual(viewController.segmentedControl.selectedSegmentIndex, index)
```
___

Selects the segment with title within given `UISegmentedControl`

```swift
func selectSegment(_ segmentedControl: UISegmentedControl, withTitle title: String)
```

__Parameters__

`segmentedControl`: `UISegmentedControl` instance to update  
`title`: Title of segment to tap

__Example__

```swift
let title = "Second"
        
selectSegment(viewController.segmentedControl, withTitle: title)

XCTAssertEqual(viewController.segmentedControl.titleForSegment(at: viewController.segmentedControl.selectedSegmentIndex), title)
```

___

Selects the segment with specified image of given `UISegmentedControl`

```swift
func selectSegment(_ segmentedControl: UISegmentedControl, withImage image: UIImage)
```

__Parameters__

`segmentedControl`: `UISegmentedControl` instance to update  
`image`: Image of segment to tap

__Example__

```swift
let image = UIImage.lock()

selectSegment(viewController.segmentedControl, withImage: image)

XCTAssertEqual(viewController.segmentedControl.imageForSegment(at: 1), image)
```

___
### UISwitch

___
### UISlider

___
### UIStepper

___
### UITabBar / UITabBarController
