//
//  Created by Kateryna Gridina.
//  Copyright (c) gridNA. All rights reserved.
//  Latest version can be found at https://github.com/gridNA/GNAContextMenu
//

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
    private var angleCoef: CGFloat!
    private var xDistanceToItem: CGFloat!
    private var yDistanceToItem: CGFloat!
    
    // MARK: Init section
    
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
    
    // MARK: Public methods
    
    func handleGesture(gesture: UILongPressGestureRecognizer, inView: UIView) {
        let point = gesture.locationInView(inView)
        if(gesture.state == .Began)
        {
            showMenuView(inView: inView, atPoint: point)
        }
        else if(gesture.state == .Changed)
        {
            slideToPoint(point)
        }
        else if(gesture.state == .Ended)
        {
            dismissMenuView(point)
        }
    }
    
    func showMenuView(#inView: UIView, atPoint: CGPoint) {
        inView.addSubview(self)
        frame = (UIApplication.sharedApplication().keyWindow?.subviews[0] as! UIView).bounds
        touchPoint = atPoint
        touchPointImage.center = touchPoint
        angleCoef = 90.0 / CGFloat(menuItemsArray.count - 1)
        currentDirection = calculateDirections(menuItemsArray[0].frame.width)
        setupMenuView()
    }
    
    func slideToPoint(point: CGPoint) {
        if touchPoint == nil {
            return
        }
        detectPoint(point, action: { (menuItem: MenuItem) in
            self.activateItem(menuItem)
        })
    }
    
    func dismissMenuView(point: CGPoint) {
        detectPoint(point, action: { (menuItem: MenuItem) in
            delegate?.menuItemWasPressed?(menuItem, info: additionalInfo)
        })
        deactivateCurrentItem()
        self.removeFromSuperview()
    }
    
    // MARK: Private methods
    
    private func setupMenuView() {
        calculateDistanceToItem()
        resetItemsPosition()
        anglesForDirection()
        for item in menuItemsArray {
            self.addSubview(item)
            animateItem(item)
        }
    }
    
    private func resetItemsPosition() {
        menuItemsArray.map({
            $0.center = self.touchPointImage.center
        })
    }
    
    private func calculateDistanceToItem() {
        xDistanceToItem = touchPointImage.frame.width/2 + distanceToTouchPoint + CGFloat(menuItemsArray[0].frame.width/2)
        yDistanceToItem = touchPointImage.frame.height/2 + distanceToTouchPoint + CGFloat(menuItemsArray[0].frame.height/2)
    }
    
    private func detectPoint(point: CGPoint, action: (menuItem: MenuItem)->Void) {
        var p = self.convertPoint(point, fromView: superview)
        var isActiveButton = false
        for subview in self.subviews {
            if CGRectContainsPoint(subview.frame, p) && subview is MenuItem {
                isActiveButton = true
                action(menuItem: subview as! MenuItem)
            }
        }
        if let item = currentActiveItem where !isActiveButton {
            if CGRectContainsPoint(touchPointImage.frame, point) {
                deactivateItem(item)
            }
        }
    }
    
    private func calculateDirections(menuItemWidth: CGFloat) -> (Direction, Direction) {
        var superViewFrame = self.superview?.frame
        var touchWidth = distanceToTouchPoint +  menuItemWidth + touchPointImage.frame.width
        var touchHeight = distanceToTouchPoint + menuItemWidth + touchPointImage.frame.height
        var horisontalDirection = determineHorisontalDirection(touchWidth, superViewFrame: superViewFrame!)
        var verticalDirection = determineVerticalDirection(touchHeight, superViewFrame: superViewFrame!)
        return(verticalDirection, horisontalDirection)
    }
    
    private func determineVerticalDirection(size: CGFloat, superViewFrame: CGRect) -> Direction {
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
    
    private func determineHorisontalDirection(size: CGFloat, superViewFrame: CGRect) -> Direction {
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
    
    private func anglesForDirection() {
        switch (self.currentDirection as (Direction, Direction)) {
        case (.Down, .Left), (.Down, .Middle):
            negativeQuorterAngles(startAngle: 90)
            break
        case (.Down, .Right):
            positiveQuorterAngle(startAngle: 0)
            break
        case (.Middle, .Left), (.Middle, .Middle), (.Up, .Left), (.Up, .Middle):
            negativeQuorterAngles(startAngle: 180)
            break
        case (.Middle, .Right), (.Up, .Right):
            positiveQuorterAngle(startAngle: 270)
            break
        default:
            break
        }
    }
    
    private func negativeQuorterAngles(#startAngle: CGFloat) {
        let angle = startAngle + 90
        menuItemsArray.map({ item -> MenuItem in
            let index = CGFloat(find(self.menuItemsArray, item)!)
            item.angle = (angle - self.angleCoef * index) / 180 * CGFloat(M_PI)
            return item
        })
    }
    
    private func positiveQuorterAngle(#startAngle: CGFloat) {
        menuItemsArray.map({ item -> MenuItem in
            let index = CGFloat(find(self.menuItemsArray, item)!)
            item.angle = (startAngle + self.angleCoef * index) / 180.0 * CGFloat(M_PI)
            return item
        })
    }
    
    private func animateItem(menuItem: MenuItem) {
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1, options: nil, animations: {
                menuItem.center = CGPointMake(self.calculatePointCoordiantes(menuItem.angle))
            }, completion: nil)
    }
    
    private func calculatePointCoordiantes(angle: CGFloat) -> (CGFloat, CGFloat) {
        if xDistanceToItem == nil || yDistanceToItem == nil {
            calculateDistanceToItem()
        }
        let x = touchPoint.x + cos(angle) * xDistanceToItem
        let y = touchPoint.y + sin(angle) * yDistanceToItem
        return (x, y)
    }

    // MARK: Buttons actiovation/deactivation
    
    private func activateItem(menuItem: MenuItem) {
        if currentActiveItem != menuItem {
            deactivateCurrentItem()
            currentActiveItem = menuItem
            distanceToTouchPoint = distanceToTouchPoint + CGFloat(15.0)
            setupPositionAnimated(menuItem)
            menuItem.activate(shouldActivate: true)
            delegate?.menuItemActivated?(menuItem, info: additionalInfo)
        }
    }
    
    private func deactivateItem(menuItem: MenuItem) {
        if let item = currentActiveItem {
            currentActiveItem = nil
            distanceToTouchPoint = distanceToTouchPoint - CGFloat(15.0)
            setupPositionAnimated(menuItem)
            menuItem.activate(shouldActivate: false)
            delegate?.menuItemDeactivated?(menuItem, info: additionalInfo)
        }
    }
    
    private func deactivateCurrentItem() {
        if let item = currentActiveItem {
            deactivateItem(item)
        }
    }
    
    private func setupPositionAnimated(menuItem: MenuItem) {
        calculateDistanceToItem()
        UIView.animateWithDuration(0.2, animations: {
             menuItem.center = CGPointMake(self.calculatePointCoordiantes(menuItem.angle))
        })
    }
}
