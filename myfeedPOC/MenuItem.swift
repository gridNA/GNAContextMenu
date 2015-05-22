//
//  MenuItemView.swift
//  myfeedPOC
//
//  Created by Kateryna Gridina on 12/05/15.
//  Copyright (c) gridNA. All rights reserved.
//

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
            UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1, options: nil, animations: {
                titleView.center = CGPoint(x: self.frame.width/2, y: -self.titleLabel.frame.height)
            }, completion: nil)
        }
    }
    
    /// Non-annotated text like this appears in "Description".
    /// This top line appears slightly more separated, as a kind of abstract.
    ///
    /// Leave a blank line to separate further text into paragraphs.
    ///
    /// You can use bulleted lists (use `-`, `+` or `*`):
    ///
    /// - Text can be *emphasised*
    /// - Or **strong**
    /// - You can use backticks for `code()`
    ///
    /// Or numbered lists:
    ///
    /// 1. The numbers you use make no difference
    /// 0. The list will still be ordered
    /// 5. But be sensible and just use 1, 2, 3 etc…
    ///
    /// Indentation will create a code block, handy for example usage:
    ///
    ///     // Create an integer, and do nothing with it
    ///     let myInt = 42
    ///     doNothing(myInt)
    ///
    ///         // Further indentations create nested code blocks. Also notice that code blocks scroll horizontally instead of wrapping.
    ///
    ///
    /// :param: int A pointless `Int` paramater.
    /// :param: bool This `Bool` isn't used, but its default value is `false` anyway…
    /// :returns: Nothing useful.
    func activate(#shouldActivate: Bool) {
        menuIcon.hidden = shouldActivate
        activeMenuIcon?.hidden = !shouldActivate
        showHideTitle(!shouldActivate)
    }
}
