//
//  ZContextView.swift
//  myfeedPOC
//
//  Created by Kateryna Gridina on 12/05/15.
//  Copyright (c) 2015 zalando. All rights reserved.
//

import Foundation
import UIKit

class ZContextMenuView: UIView {
    
    var shouldPresentContextMenu = false
    var menuView = MenuView(menuItems: [MenuItem(icon: UIImage(named: "shopingCart_inactive"), activeIcon: UIImage(named: "shopingCart"), title: "Shop it"), MenuItem(icon: UIImage(named: "wishlist_inacitve"), activeIcon: UIImage(named: "wishlist"), title: "Wish"), MenuItem(icon: UIImage(named: "wishlist_inacitve"), activeIcon: UIImage(named: "wishlist"), title: "Wish")])
    
    override func touchesBegan(touches:Set<NSObject>, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
        
        if let touch = touches.first as? UITouch {
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                self.presentContexMenu(touch)
            }
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesEnded(touches, withEvent: event)
        if(shouldPresentContextMenu == true) {
            if let touch = touches.first as? UITouch {
                dismissContextMenu(touch)
            }
            shouldPresentContextMenu = false
        } else {
            // TODO: handle tap here
        }
    }
    
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesMoved(touches, withEvent: event)
        if let touch = touches.first as? UITouch {
            menuView.slideToPoint(touch.locationInView(self))
        }
    }
    
    func presentContexMenu(touch: UITouch) {
        self.shouldPresentContextMenu = true
        menuView.showMenuView(inView: self, atPoint: touch.locationInView(self))
    }
    
    func dismissContextMenu(touch: UITouch) {
        self.shouldPresentContextMenu = false
        menuView.dismissMenuView(touch.locationInView(self))
    }
}
