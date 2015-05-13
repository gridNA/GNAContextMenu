//
//  ViewController.swift
//  myfeedPOC
//
//  Created by Kateryna Gridina on 12/05/15.
//  Copyright (c) 2015 zalando. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let v = ZContextMenuView(frame:CGRectMake(0, 0, 300, 300))
        //v.backgroundColor = UIColor.redColor()
        view.addSubview(v)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

