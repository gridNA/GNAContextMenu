//
//  MenuView.swift
//  myfeedPOC
//
//  Created by Kateryna Gridina on 12/05/15.
//  Copyright (c) gridNA. All rights reserved.
//

import Foundation
import UIKit

enum Direction {
    case Left
    case Right
    case Middle
    case Up
    case Down
}

@objc protocol MenuItemDelegate {
    optional func menuItemWasPressed(menuItem: MenuItem, info: [String: AnyObject]?)
    optional func menuItemActivated(menuItem: MenuItem, info: [String: AnyObject]?)
    optional func menuItemDeactivated(menuItem: MenuItem, info: [String: AnyObject]?)
}

class MenuView: UIView {
    var distanceToTouchPoint: CGFloat = 20
    var delegate: MenuItemDelegate?
    var additionalInfo: [String: AnyObject]?
    private var touchPoint: CGPoint!
    private var menuItemsArray: Array<MenuItem>!
    private var coordinatesDict: [String: CGFloat]!
    private var currentDirection: (Direction, Direction)!
    private var currentActiveItem: MenuItem?
    private var touchPointImage: UIImageView!
    
    private init(frame: CGRect, image: UIImage) {
        touchPointImage = UIImageView(image: image)
        touchPointImage.contentMode = UIViewContentMode.ScaleAspectFit
        super.init(frame: frame)
        touchPointImage.frame = self.bounds
        self.addSubview(touchPointImage)
    }
    
    convenience init(menuItems: Array<MenuItem>) {
        self.init(size: CGSize(width: 80, height: 80), image: UIImage(named: "defaultImage")!, menuItems: menuItems)
    }
    
    convenience init(size: CGSize, image: UIImage, menuItems: Array<MenuItem>) {
        self.init(frame: CGRect(origin: CGPointMake(0, 0), size: size), image: image)
        menuItemsArray = menuItems
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func calculateCoordinates() {
        var halfItemWidth = CGFloat(menuItemsArray[0].frame.width/2)
        let c1 = touchPoint.x + touchPointImage.frame.width/2 + distanceToTouchPoint + halfItemWidth
        let c2 = touchPoint.x - (c1 - touchPoint.x)
        let c4 = c1 - halfItemWidth
        let c5 = touchPoint.x
        let c6 = c2 + halfItemWidth
        
        let c3 = touchPoint.y
        let c8 = touchPoint.y + touchPointImage.frame.height/2 + distanceToTouchPoint + halfItemWidth
        let c9 = touchPoint.y - (c8 - touchPoint.y)
        let c7 = c8 - halfItemWidth
        let c10 = c9 + halfItemWidth
        coordinatesDict = ["coord1": c1, "coord2": c2, "coord3": c3, "coord4": c4,
            "coord5": c5, "coord6": c6, "coord7": c7, "coord8": c8, "coord9": c9, "coord10": c10]
    }
    
    func changeDistanceToTouchPoint(distance: CGFloat) {
        self.distanceToTouchPoint = distance
        calculateCoordinates()
    }
    
    func showMenuView(#inView: UIView, atPoint: CGPoint) {
        inView.addSubview(self)
        touchPoint = atPoint
        touchPointImage.center = touchPoint
        calculateCoordinates()
        menuItemsArray.map({
            (var menuItem) -> MenuItem in
            menuItem.center = self.touchPointImage.center //CGRect(origin: CGPointZero, size: menuItem.frame.size)
            return menuItem
        })
        displayMenuItems()
    }
    
    func displayMenuItems() {
        var itemNumber = Int(0)
        for menuItem in menuItemsArray {
            itemNumber++
            if itemNumber > 3 {
                break
            }
            menuItem.itemNumber = itemNumber
            frame = (UIApplication.sharedApplication().keyWindow?.subviews[0] as! UIView).bounds
            animateToPosition(menuItem)
            self.addSubview(menuItem)
        }
    }
    
    func animateToPosition(menuItem: MenuItem) {
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1, options: nil, animations: {
            self.currentDirection = self.calculateDirections(menuItem.frame.width)
            self.setupPosition(menuItem)
        }, completion: nil)
    }
    
    func setupPosition(menuItem: MenuItem) {
        switch (self.currentDirection as (Direction, Direction)) {
        case (.Down, .Left), (.Down, .Middle):
            self.setupDownRigt(menuItem)
            break
        case (.Down, .Right):
            self.setupDownLeft(menuItem)
            break
        case (.Middle, .Left), (.Middle, .Middle), (.Up, .Left), (.Up, .Middle):
            self.setupUpLeft(menuItem)
            break
        case (.Middle, .Right), (.Up, .Right):
            self.setupUpRight(menuItem)
            break
        default:
            break
        }
    }
    
    func calculateDirections(menuItemWidth: CGFloat) -> (Direction, Direction) {
        var superViewFrame = self.superview?.frame
        var touchWidth = distanceToTouchPoint +  menuItemWidth + touchPointImage.frame.width
        var touchHeight = distanceToTouchPoint + menuItemWidth + touchPointImage.frame.height
        var horisontalDirection = determineHorisontalDirection(touchWidth, superViewFrame: superViewFrame!)
        var verticalDirection = determineVerticalDirection(touchHeight, superViewFrame: superViewFrame!)
        return(verticalDirection, horisontalDirection)
    }
    
    func setupDownLeft(menuItem: MenuItem) {
        switch(menuItem.itemNumber) {
        case 1:
            menuItem.center = CGPointMake(coordinatesDict["coord1"]!, coordinatesDict["coord3"]!)
            break
        case 2:
            menuItem.center = CGPointMake(coordinatesDict["coord4"]!, coordinatesDict["coord7"]!)
            break
        case 3:
            menuItem.center = CGPointMake(coordinatesDict["coord5"]!, coordinatesDict["coord8"]!)
            break
        default:
            break
        }
    }
    
    func setupDownRigt(menuItem: MenuItem) {
        switch(menuItem.itemNumber) {
        case 1:
            menuItem.center = CGPointMake(coordinatesDict["coord2"]!, coordinatesDict["coord3"]!)
            break
        case 2:
            menuItem.center = CGPointMake(coordinatesDict["coord6"]!, coordinatesDict["coord7"]!)
            break
        case 3:
            menuItem.center = CGPointMake(coordinatesDict["coord5"]!, coordinatesDict["coord8"]!)
            break
        default:
            break
        }
    }
    
    func setupUpLeft(menuItem: MenuItem) {
        switch(menuItem.itemNumber) {
        case 1:
            menuItem.center = CGPointMake(coordinatesDict["coord5"]!, coordinatesDict["coord9"]!)
            break
        case 2:
            menuItem.center = CGPointMake(coordinatesDict["coord6"]!, coordinatesDict["coord10"]!)
            break
        case 3:
            menuItem.center = CGPointMake(coordinatesDict["coord2"]!, coordinatesDict["coord3"]!)
            break
        default:
            break
        }
    }
    
    func setupUpRight(menuItem: MenuItem) {
        switch(menuItem.itemNumber) {
        case 1:
            menuItem.center = CGPointMake(coordinatesDict["coord5"]!, coordinatesDict["coord9"]!)
            break
        case 2:
            menuItem.center = CGPointMake(coordinatesDict["coord4"]!, coordinatesDict["coord10"]!)
            break
        case 3:
            menuItem.center = CGPointMake(coordinatesDict["coord1"]!, coordinatesDict["coord3"]!)
            break
        default:
            break
        }
    }
    
    func determineVerticalDirection(size: CGFloat, superViewFrame: CGRect) -> Direction {
        let isBotomBorderOfScreen = touchPoint.y + size > UIScreen.mainScreen().bounds.height
        let isTopBorderOfScreen = touchPoint.y - size < 0
        if  isTopBorderOfScreen {
            return .Down
        } else if isBotomBorderOfScreen {
            return .Up
        } else {
            return .Middle
        }
    }
    
    func determineHorisontalDirection(size: CGFloat, superViewFrame: CGRect) -> Direction {
        let isRightBorderOfScreen = touchPoint.x + size > UIScreen.mainScreen().bounds.width
        let isLeftBorderOfScreen = touchPoint.x - size < 0
        if isLeftBorderOfScreen {
            return .Right
        } else if  isRightBorderOfScreen {
            return .Left
        } else {
            return .Middle
        }
    }
   
    func slideToPoint(point: CGPoint) {
        if touchPoint == nil {
            return
        }
        detectPoint(point, action: { (menuItem: MenuItem) in
            self.activateItem(menuItem)
        })
    }
    
    func activateItem(menuItem: MenuItem) {
        if currentActiveItem != menuItem {
            deactivateCurrentItem()
            currentActiveItem = menuItem
            distanceToTouchPoint = distanceToTouchPoint + CGFloat(15.0)
            calculateCoordinates()
            setupPositionAnimated(menuItem)
            menuItem.makeActive()
            delegate?.menuItemActivated?(menuItem, info: additionalInfo)
        }
    }
    
    func deactivateItem(menuItem: MenuItem) {
        if let item = currentActiveItem {
            currentActiveItem = nil
            distanceToTouchPoint = distanceToTouchPoint - CGFloat(15.0)
            calculateCoordinates()
            setupPositionAnimated(menuItem)
            menuItem.makeInactive()
            delegate?.menuItemDeactivated?(menuItem, info: additionalInfo)
        }
    }
    
    func deactivateCurrentItem() {
        if let item = currentActiveItem {
            deactivateItem(item)
        }
    }
    
    func setupPositionAnimated(menuItem: MenuItem) {
        UIView.animateWithDuration(0.2, animations: {
             self.setupPosition(menuItem)
        })
    }
    
    func dismissMenuView(point: CGPoint) {
        detectPoint(point, action: { (menuItem: MenuItem) in
            delegate?.menuItemWasPressed?(menuItem, info: additionalInfo)
        })
        deactivateCurrentItem()
        self.removeFromSuperview()
    }
    
    func detectPoint(point: CGPoint, action: (menuItem: MenuItem)->Void) {
        var p = self.convertPoint(point, fromView: superview)
        var isActiveButton = false
        for subview in self.subviews {
            if CGRectContainsPoint(subview.frame, p) && subview is MenuItem {
                isActiveButton = true
                action(menuItem: subview as! MenuItem)
            }
        }
        if let item = currentActiveItem where !isActiveButton {
            if CGRectContainsPoint(touchPointImage.frame, point)  {
                deactivateItem(item)
            }
        }
    }
}
