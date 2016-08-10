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
        // Dyynamically Integrated Off Swith Setting Recommended
        var isFreezing: Bool? = userDefaults.objectForKey("freeze") as! Bool?
        if(isFreezing == nil){
            isFreezing = true
            userDefaults.setObject(isFreezing, forKey: "freeze")
        }
        global.freezeTime = isFreezing!
        if(isFreezing!){
            freezeTimeSwitch.setOn(true, animated: false)
        }
        else{
            freezeTimeSwitch.setOn(false, animated: false)
        }
        var inspection: Bool? = userDefaults.objectForKey("inspect") as! Bool?
        if(inspection == nil){
            inspection = false
            userDefaults.setObject(isFreezing, forKey: "inspect")
        }
        global.inspectionTime = inspection!
        if(inspection!){
            inspectionTimeSwitch.setOn(true, animated: false)
        }
        else{
            inspectionTimeSwitch.setOn(false, animated: false)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated...
    }
    
    @IBOutlet weak var freezeTimeSwitch: UISwitch!
    
    @IBOutlet weak var inspectionTimeSwitch: UISwitch!
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    func freezeSwitchIsChanged(mySwitch: UISwitch) {
        var isFreezing: Bool
        if mySwitch.on {
            global.freezeTime = true
            isFreezing = true
        } else {
            global.freezeTime = false
            isFreezing = false
        }
        userDefaults.setObject(isFreezing, forKey: "freeze")
    }
    
    
    func inspectionSwitchIsChanged(mySwitch: UISwitch) {
        var inspection: Bool
        if mySwitch.on {
            global.inspectionTime = true
            inspection = true
        } else {
            global.inspectionTime = false
            inspection = false
        }
        userDefaults.setObject(inspection, forKey: "inspect")
    }

}
