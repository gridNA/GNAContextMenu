[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

# GNAContextMenu

Long press context menu (like in Pintrest iOS app)

## Requirements

- iOS 8.0+
- Xcode 6.3+

## Installation

Or [Carthage](https://github.com/Carthage/Carthage). Add the depdency to your `Cartfile` and then `carthage update`:

```ogdl
github "gridNA/GNAContextMenu" >= 1
```

## How

1)```swift
import GNAContextMenu
```
2) add 
```swift UILongPressGestureRecognizer```on view in UIViewController, where you plan to use context menu

3) create GNAMenuView and set delegate 
```swift
var menuView = GNAMenuView(menuItems: [GNAMenuItem(icon: UIImage(named: "shopingCart_inactive"), activeIcon: UIImage(named: "shopingCart"), title: "Shop it"), 
              GNAMenuItem(icon: UIImage(named: "wishlist_inacitve"), activeIcon: UIImage(named: "wishlist"), title: "Wish")])
menuView.delegate = self
```
4) on long press in view call 
```swift menuView.handleGesture(gesture, inView: yourView)```

You can also implement GNAMenuItemDelegate methods:
```swift
  menuItemWasPressed(menuItem: GNAMenuItem, info: [String: AnyObject]?)
  menuItemActivated(menuItem: GNAMenuItem, info: [String: AnyObject]?)
  menuItemDeactivated(menuItem: GNAMenuItem, info: [String: AnyObject]?)
```
Please see example for more info.
