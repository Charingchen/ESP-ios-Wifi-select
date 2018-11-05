//
//  passwordViewController.swift
//  ESP ios Wifi select
//
//  Created by Hanxiang Chen on 2018-11-05.
//  Copyright © 2018 Haxen Tech. All rights reserved.
//

import UIKit
var ssid: Ssid?
class passwordViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let wifiListVC = storyboard?.instantiateViewController(withIdentifier: "wifilistview") as! WifiListScreenViewController
        wifiListVC.ssidDelegate = self
        ssidTextField.text = ssid?.id
        
    }
    
    @IBOutlet weak var ssidTextField: UITextView!
    
    @IBAction func passwordEntered(_ sender: Any) {
        
    }
    

}

extension passwordViewController : ssidSelectDelegate{
    func didTapSSID(ssidInfo: Ssid) {
        ssid = ssidInfo
    }
}
