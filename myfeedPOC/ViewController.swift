//
//  ViewController.swift
//  myfeedPOC
//
//  Created by Kateryna Gridina on 12/05/15.
//  Copyright (c) 2015 zalando. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ZContextMenuViewDelegate, MenuItemDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        let menuView = MenuView(menuItems: [MenuItem(icon: UIImage(named: "shopingCart_inactive"), activeIcon: UIImage(named: "shopingCart"), title: "Shop it"), MenuItem(icon: UIImage(named: "wishlist_inacitve"), activeIcon: UIImage(named: "wishlist"), title: "Wish"), MenuItem(icon: UIImage(named: "wishlist_inacitve"), activeIcon: UIImage(named: "wishlist"), title: "Wish")])
        menuView.delegate = self
        let v = ZContextMenuView(frame:CGRectMake(0, 0, 300, 300), menuView: menuView, info: nil)
        v.delegate = self
        //v.backgroundColor = UIColor.redColor()
        view.addSubview(v)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func itemIsTapped(additionalInfo: [String: AnyObject]?) {
        println("tapped")
    }
    
    func menuItemWasPressed(menuItem: MenuItem, info: [String: AnyObject]?) {
        println("item pressed")
    }

}

