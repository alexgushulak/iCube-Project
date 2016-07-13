//
//  SettingsViewController.swift
//  iCube2
//
//  Created by Alex on 7/6/16.
//  Copyright © 2016 Dangle. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var freezeTimeSwitch: UISwitch!
    
    @IBOutlet weak var inspectionTimeSwitch: UISwitch!
    
    struct globals {
        var freezeTime = true
        static var inspectionTime = false
    }
    if(globals.freezeTime){
    
    }
    
    
}
