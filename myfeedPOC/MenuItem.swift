//
//  MenuItemView.swift
//  myfeedPOC
//
//  Created by Kateryna Gridina on 12/05/15.
//  Copyright (c) 2015 zalando. All rights reserved.
//

import Foundation
import UIKit

class MenuItem: UIView {
    var pressAction: (()->Void)?
    var itemNumber: Int!
    private var menuIcon: UIImageView!
    private var activeMenuIcon: UIImageView?
    
    init(icon: UIImage!, activeIcon: UIImage?, title: String?) {
        var frame = CGRectMake(0, 0, 60, 60)
        super.init(frame: frame)
        menuIcon = createMenuIcon(icon)
        activeMenuIcon = createMenuIcon(activeIcon == nil ? icon : activeIcon)
        makeInactive()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createMenuIcon(menuIconImage: UIImage) -> UIImageView {
        var iconView = UIImageView(image: menuIconImage)
        iconView.frame = self.bounds
        iconView.contentMode = UIViewContentMode.ScaleAspectFit
        self.addSubview(iconView)
        return iconView
    }
    
    func makeActive() {
        menuIcon.hidden = true
        activeMenuIcon?.hidden = false
    }
    
    func makeInactive() {
        menuIcon.hidden = false
        activeMenuIcon?.hidden = true
    }
}
