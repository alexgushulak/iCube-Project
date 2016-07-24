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
        freezeTimeSwitch.addTarget(self, action: #selector(SettingsViewController.freezeSwitchIsChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
        inspectionTimeSwitch.addTarget(self, action: #selector(SettingsViewController.inspectionSwitchIsChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
        inspectionTimeSwitch.setOn(false, animated: false)
        // Dynamically Integrated Off Swith Setting Recommended
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated...
    }
    
    @IBOutlet weak var freezeTimeSwitch: UISwitch!
    
    @IBOutlet weak var inspectionTimeSwitch: UISwitch!
    
    func freezeSwitchIsChanged(mySwitch: UISwitch) {
        if mySwitch.on {
            global.freezeTime = true
        } else {
            global.freezeTime = false
        }
    }
    
    
    func inspectionSwitchIsChanged(mySwitch: UISwitch) {
        if mySwitch.on {
            global.inspectionTime = true
        } else {
            global.inspectionTime = false
        }
    }

}
