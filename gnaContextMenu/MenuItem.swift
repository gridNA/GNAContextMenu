//
//  Created by Kateryna Gridina.
//  Copyright (c) gridNA. All rights reserved.
//  Latest version can be found at https://github.com/gridNA/GNAContextMenu
//

import UIKit

class MenuItem: UIView {
    var titleLabel: UILabel!
    var titleView: UIView!
    var itemId: String?
    var angle: CGFloat!
    
    private var menuIcon: UIImageView!
    private var titleText: String?
    private var activeMenuIcon: UIImageView?
    
    convenience init(icon: UIImage!, activeIcon: UIImage?, title: String?) {
        var frame = CGRectMake(0, 0, 55, 55)
        self.init(icon: icon, activeIcon: activeIcon, title: title, frame: frame)
    }
    
    init(icon: UIImage!, activeIcon: UIImage?, title: String?, frame: CGRect) {
        super.init(frame: frame)
        menuIcon = createMenuIcon(icon)
        activeMenuIcon = createMenuIcon(activeIcon == nil ? icon : activeIcon)
        createLabel(title)
        activate(shouldActivate: false)
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
            UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1, options: nil, animations: {
                titleView.center = CGPoint(x: self.frame.width/2, y: -self.titleLabel.frame.height)
            }, completion: nil)
        }
    }
    
    func activate(#shouldActivate: Bool) {
        menuIcon.hidden = shouldActivate
        activeMenuIcon?.hidden = !shouldActivate
        showHideTitle(!shouldActivate)
    }
    
    func createCustomLabel(label: UILabel) {
        if let title = titleText {
            titleLabel = label
            setupLabel()
        }
    }
    
    func changeTitle(#newTitle: String) {
        titleLabel.text = newTitle
    }
    
    func changeIcon(#newIcon: UIImage) {
        menuIcon.image = newIcon
    }
    
    func changeActiveIcon(#newActiveIcon: UIImage) {
        activeMenuIcon?.image = newActiveIcon
    }
}
