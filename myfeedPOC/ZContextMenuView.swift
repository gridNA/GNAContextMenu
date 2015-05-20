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
    var contextMenuIsPresented = false
    var menuView: MenuView
    private var additionalInfo: [String: AnyObject]?
    
    init(frame: CGRect, menuView menu: MenuView, info: [String: AnyObject]!) {
        menuView = menu
        additionalInfo = info
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches:Set<NSObject>, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
        
        if let touch = touches.first as? UITouch {
            shouldPresentContextMenu = true
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                if self.shouldPresentContextMenu {
                    self.presentContexMenu(touch)
                }
            }
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesEnded(touches, withEvent: event)
        shouldPresentContextMenu = false
        if(contextMenuIsPresented == true) {
            if let touch = touches.first as? UITouch {
                dismissContextMenu(touch)
            }
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
        self.contextMenuIsPresented = true
        menuView.showMenuView(inView: self, atPoint: touch.locationInView(self))
    }
    
    func dismissContextMenu(touch: UITouch) {
        self.contextMenuIsPresented = false
        menuView.dismissMenuView(touch.locationInView(self))
    }
}
