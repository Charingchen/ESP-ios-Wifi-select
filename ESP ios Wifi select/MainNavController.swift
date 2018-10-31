//
//  MainNavController.swift
//  ESP ios Wifi select
//
//  Created by Hanxiang Chen on 2018-10-31.
//  Copyright © 2018 Haxen Tech. All rights reserved.
//

import UIKit

class MainNavController: UIViewController {

    
    @IBOutlet weak var initiConnButton: UIButton!
    @IBOutlet weak var wifiScanButton: UIButton!
    
    @IBAction func connectDidTap(_ sender: Any) {
        print("initi socket connection")
        print("socket connected")
        initiConnButton.isHidden = true
        wifiScanButton.isHidden = false
    
    }
    
    @IBAction func wifiScanDidTap(_ sender: Any) {
        print("wifi scan started")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wifiScanButton.isHidden = true
        // Do any additional setup after loading the view.
    }
    



}
