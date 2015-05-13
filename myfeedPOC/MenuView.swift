//
//  MenuView.swift
//  myfeedPOC
//
//  Created by Kateryna Gridina on 12/05/15.
//  Copyright (c) 2015 zalando. All rights reserved.
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

class MenuView: UIView {
    var distanceToTouchPoint: CGFloat = 15
    var touchPointFrame: CGRect!
    private var touchPoint: CGPoint!
    private var menuItemsArray: Array<MenuItem>!
    
    var v: UIView!
    
    private init(frame: CGRect, image: UIImage) {
        super.init(frame: frame)
        var touchPointImage = UIImageView(image: image)
        touchPointImage.frame = self.bounds
        touchPointImage.contentMode = UIViewContentMode.ScaleAspectFit
        self.addSubview(touchPointImage)
    }
    
    convenience init(menuItems: Array<MenuItem>) {
        self.init(size: CGSize(width: 50, height: 50), image: UIImage(named: "defaultImage")!, menuItems: menuItems)
    }
    
    convenience init(size: CGSize, image: UIImage, menuItems: Array<MenuItem>) {
        self.init(frame: CGRect(origin: CGPointMake(0, 0), size: size), image: image)
        menuItemsArray = menuItems
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showMenuView(#inView: UIView, atPoint: CGPoint) {
        inView.addSubview(self)
        self.center = atPoint
        touchPoint = atPoint
        menuItemsArray.map({
            (var menuItem) -> MenuItem in
            menuItem.frame = CGRect(origin: CGPointZero, size: menuItem.frame.size)
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
            createPosition(menuItem, itemNumber: itemNumber)
            self.addSubview(menuItem)
        }
    }
    
    func createPosition(menuItem: MenuItem, itemNumber: Int) {
        UIView.animateWithDuration(0.5, animations: {
        switch (self.calculateDirections(menuItem.frame.width)) {
        case (.Down, .Left), (.Down, .Middle):
            self.setupDownLeft(menuItem, itemNumber: itemNumber)
            break;
        case (.Down, .Right):
            self.setupDownRigt(menuItem, itemNumber: itemNumber)
            break;
        case (.Middle, .Left), (.Middle, .Middle), (.Up, .Left), (.Up, .Middle):
            self.setupUpLeft(menuItem, itemNumber: itemNumber)
            break;
        case (.Middle, .Right), (.Up, .Right):
            self.setupUpRight(menuItem, itemNumber: itemNumber)
            break;
        default:
            break;
        }
        })
    }
    
    func calculateDirections(menuItemWidth: CGFloat) -> (Direction, Direction) {
        var superViewFrame = self.superview?.frame
        var touchWidth = distanceToTouchPoint +  menuItemWidth + self.frame.width
        var touchHeight = distanceToTouchPoint + menuItemWidth + self.frame.height
        var horisontalDirection = determineHorisontalDirection(touchWidth, superViewFrame: superViewFrame!)
        var verticalDirection = determineVerticalDirection(touchHeight, superViewFrame: superViewFrame!)
        return(verticalDirection, horisontalDirection)
    }
    
    func setupDownLeft(menuItem: MenuItem, itemNumber: Int) {
        var halfItemWidth = CGFloat(menuItem.frame.width/2)
        if itemNumber == 1 {
            menuItem.center = CGPointMake(self.frame.width + distanceToTouchPoint + halfItemWidth, self.frame.size.height/2)
        } else if itemNumber == 2 {
            menuItem.center = CGPointMake(self.frame.width + distanceToTouchPoint, self.frame.height + distanceToTouchPoint)
        } else {
            menuItem.center = CGPointMake(self.frame.size.width/2, self.frame.height + distanceToTouchPoint + halfItemWidth)
        }
    }
    
    func setupDownRigt(menuItem: MenuItem, itemNumber: Int) {
        var halfItemWidth = CGFloat(menuItem.frame.width/2)
        if itemNumber == 1 {
            menuItem.center = CGPointMake(-(distanceToTouchPoint + halfItemWidth), self.frame.height/2)
        } else if itemNumber == 2 {
            menuItem.center = CGPointMake(-distanceToTouchPoint, self.frame.height + distanceToTouchPoint)
        } else {
            menuItem.center = CGPointMake(self.frame.size.width/2, self.frame.height + distanceToTouchPoint + halfItemWidth)
        }
    }
    
    func setupUpLeft(menuItem: MenuItem, itemNumber: Int) {
        var halfItemWidth = CGFloat(menuItem.frame.width/2)
        if itemNumber == 1 {
            menuItem.center = CGPointMake(self.frame.size.width/2, -(distanceToTouchPoint + halfItemWidth))
        } else if itemNumber == 2 {
            menuItem.center = CGPointMake(self.frame.width + distanceToTouchPoint, -distanceToTouchPoint)
        } else {
            menuItem.center = CGPointMake(self.frame.size.width + distanceToTouchPoint + halfItemWidth, self.frame.size.height/2)
        }
    }
    
    func setupUpRight(menuItem: MenuItem, itemNumber: Int) {
        var halfItemWidth = CGFloat(menuItem.frame.width/2)
        if itemNumber == 1 {
            menuItem.center = CGPointMake(self.frame.size.width/2, -(distanceToTouchPoint + halfItemWidth))
        } else if itemNumber == 2 {
            menuItem.center = CGPointMake(-distanceToTouchPoint, -distanceToTouchPoint)
        } else {
            menuItem.center = CGPointMake(-(distanceToTouchPoint + halfItemWidth), halfItemWidth)
        }
    }
    
    func determineVerticalDirection(size: CGFloat, superViewFrame: CGRect) -> Direction {
        if touchPoint.y - size < 0 {
            return .Down
        } else if superViewFrame.height - touchPoint.y < size {
            return .Up
        } else {
            return .Middle
        }
    }
    
    func determineHorisontalDirection(size: CGFloat, superViewFrame: CGRect) -> Direction {
        if touchPoint.x - size < 0 {
            return .Left
        } else if superViewFrame.width - touchPoint.x < size {
            return .Right
        } else {
            return .Middle
        }
    }
    
    func slideToPoint(point: CGPoint) {
        if touchPoint == nil {
            return
        }
        
        detectPoint(point, action: {
            // TODO: handle active state
            println("active")
            println(point)
        })
    }
    
    func dismissMenuView(point: CGPoint) {
        detectPoint(point, action: {
            // TODO: handle selection
            println("selected")
            println(point)
        })
        self.removeFromSuperview()
    }
    
    func detectPoint(point: CGPoint, action: ()->Void) {
        var p = self.convertPoint(point, fromView: superview)
        for subview in self.subviews {
            if CGRectContainsPoint(subview.frame, p) && subview is MenuItem {
                action()
            }
        }
    }
    
    func setTouchPointFrame(newFrame: CGRect){
        self.touchPointFrame = newFrame
        self.frame = touchPointFrame
    }
}
