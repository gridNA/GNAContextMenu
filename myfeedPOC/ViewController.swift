//
//  ViewController.swift
//  myfeedPOC
//
//  Created by Kateryna Gridina on 12/05/15.
//  Copyright (c) gridNA. All rights reserved.
//

import UIKit

class ViewController: UIViewController, MenuItemDelegate, UITableViewDelegate, UITableViewDataSource {

    var table: UITableView!
    var menuView: MenuView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table = UITableView()
        table.frame = view.bounds
        view.addSubview(table)
        table.delegate = self
        table.dataSource = self
        table.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: "handleLongPress:"))
        menuView = MenuView(menuItems: [MenuItem(icon: UIImage(named: "shopingCart_inactive"), activeIcon: UIImage(named: "shopingCart"), title: "Shop it"), MenuItem(icon: UIImage(named: "wishlist_inacitve"), activeIcon: UIImage(named: "wishlist"), title: "Wish"), MenuItem(icon: UIImage(named: "wishlist_inacitve"), activeIcon: UIImage(named: "wishlist"), title: "Wish")])
        menuView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "reuseIdentifier")
        let b = UIButton(frame: CGRectMake(0, 0, 30, 30))
        b.setTitle("✸", forState: .Normal)
        b.backgroundColor = UIColor.grayColor()
        b.addTarget(self, action: "pressed:", forControlEvents: .TouchUpInside)
        cell.addSubview(b)
        return cell
    }
    
    func pressed(sender: UIButton!) {
        println("button touch")
    }
    
    func handleLongPress(gesture: UILongPressGestureRecognizer) {
        let point = gesture.locationInView(table)
        let indexPath = table.indexPathForRowAtPoint(point)
        if let p = indexPath {
            menuView.additionalInfo = ["cellPath": p]
        }
        menuView.handleGesture(gesture, inView: table)
    }
    
    func menuItemWasPressed(menuItem: MenuItem, info: [String: AnyObject]?) {
        var indexPath = info!["cellPath"] as? NSIndexPath
        println("\(indexPath)")
    }
}

