//
//  Created by Kateryna Gridina.
//  Copyright (c) gridNA. All rights reserved.
//  Latest version can be found at https://github.com/gridNA/GNAContextMenu
//

import UIKit

class ViewController: UIViewController, GNAMenuItemDelegate, UITableViewDelegate, UITableViewDataSource {

    var table: UITableView!
    var menuView: GNAMenuView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table = UITableView()
        table.frame = view.bounds
        view.addSubview(table)
        table.delegate = self
        table.dataSource = self
        table.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: "handleLongPress:"))
        menuView = GNAMenuView(menuItems: [GNAMenuItem(icon: UIImage(named: "shopingCart_inactive"), activeIcon: UIImage(named: "shopingCart"), title: "Shop it"), GNAMenuItem(icon: UIImage(named: "wishlist_inacitve"), activeIcon: UIImage(named: "wishlist"), title: "Wish"), GNAMenuItem(icon: UIImage(named: "wishlist_inacitve"), activeIcon: UIImage(named: "wishlist"), title: "Wish")])
        menuView.delegate = self
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "reuseIdentifier")
        cell.textLabel?.text = "Some title"
        return cell
    }
    
    func handleLongPress(gesture: UILongPressGestureRecognizer) {
        let point = gesture.locationInView(table)
        let indexPath = table.indexPathForRowAtPoint(point)
        if let p = indexPath {
            menuView.additionalInfo = ["cellPath": p]
        }
        3)
    }
    
    func menuItemWasPressed(menuItem: GNAMenuItem, info: [String: AnyObject]?) {
        var indexPath = info!["cellPath"] as? NSIndexPath
        println("\(indexPath)")
    }
}

