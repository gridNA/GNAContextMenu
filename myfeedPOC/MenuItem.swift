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
    var itemNumber: Int!
    var titleLabel: UILabel!
    var titleView: UIView!
    var itemId: String?
    private var menuIcon: UIImageView!
    private var titleText: String?
    private var activeMenuIcon: UIImageView?
    
    convenience init(icon: UIImage!, activeIcon: UIImage?, title: String?) {
        var frame = CGRectMake(0, 0, 60, 60)
        self.init(icon: icon, activeIcon: activeIcon, title: title, frame: frame)
        menuIcon = createMenuIcon(icon)
        activeMenuIcon = createMenuIcon(activeIcon == nil ? icon : activeIcon)
        createLabel(title)
        makeInactive()
    }
    
    init(icon: UIImage!, activeIcon: UIImage?, title: String?, frame: CGRect) {
        super.init(frame: frame)
        menuIcon = createMenuIcon(icon)
        activeMenuIcon = createMenuIcon(activeIcon == nil ? icon : activeIcon)
        createLabel(title)
        makeInactive()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createLabel(title: String?) {
        if let itemTitle = title {
            titleText = itemTitle
            titleView = UIView()
            titleLabel = UILabel()
            titleLabel.font = UIFont.systemFontOfSize(11, weight: 1)
            titleLabel.textColor = UIColor.whiteColor()
            titleLabel.textAlignment = .Center
            setupLabel()
            titleView.backgroundColor = UIColor.blackColor()
            titleView.alpha = 0.7
            titleView.layer.cornerRadius = 5
            titleView.addSubview(titleLabel)
            self.addSubview(titleView)
        }
    }
    
    func createCustomLabel(label: UILabel) {
        if let title = titleText {
            titleLabel = label
            setupLabel()
        }
    }
    
    private func setupLabel() {
        if let title = titleText {
            titleLabel.text = title
            titleLabel.sizeToFit()
            titleView.frame = CGRect(origin: CGPointZero, size: CGSize(width: titleLabel.frame.width + 6, height: titleLabel.frame.height))
            titleLabel.center = CGPoint(x: titleView.frame.width/2, y: titleView.frame.height/2)
        }
    }
    
    private func createMenuIcon(menuIconImage: UIImage) -> UIImageView {
        var iconView = UIImageView(image: menuIconImage)
        iconView.frame = self.bounds
        iconView.contentMode = UIViewContentMode.ScaleAspectFit
        self.addSubview(iconView)
        return iconView
    }
    
    private func showHideTitle(hiddenState: Bool) {
        if let titleView = titleView {
            titleView.hidden = hiddenState
            titleView.center = CGPoint(x: self.frame.width/2, y: -titleLabel.frame.height)
        }
    }
    
    func makeActive() {
        menuIcon.hidden = true
        activeMenuIcon?.hidden = false
        showHideTitle(false)
    }
    
    func makeInactive() {
        menuIcon.hidden = false
        activeMenuIcon?.hidden = true
        showHideTitle(true)
    }
}
