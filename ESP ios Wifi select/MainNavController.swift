//
//  MainNavController.swift
//  ESP ios Wifi select
//
//  Created by Hanxiang Chen on 2018-10-31.
//  Copyright © 2018 Haxen Tech. All rights reserved.
//

import UIKit

// BOSS Delegate: protocol function setup to tell the intern what to do. A list of command for Interns
//protocol wifiInfoDelegate {
//    func didTapWifiScan (wifiList: [Ssid])
//}

class MainNavController: UIViewController {
    //Need this delegate variable to pass from BOSS to Intern
    //var wifidelegate: wifiInfoDelegate!
    
    @IBOutlet weak var initiConnButton: UIButton!
    @IBOutlet weak var wifiScanButton: UIButton!
    
    @IBAction func connectDidTap(_ sender: Any) {
        print("initi socket connection")
        print("socket connected")
        
        //hide initiConnButton and show WifiScan button
        initiConnButton.isHidden = true
        wifiScanButton.isHidden = false
    
    }
    
    @IBAction func wifiScanDidTap(_ sender: Any) {
        print("wifi scan started")
        //prepare sample ssid and wifi image
        let listTosend = createArray()
        //Set up wifiListScreenViewController
        let wifiVC = storyboard?.instantiateViewController(withIdentifier: "wifilistview") as! WifiListScreenViewController
        //need this line to initial wifidelegate and point to wifilistScreenController
        // self.wifidelegate = wifiVC
       // wifidelegate.didTapWifiScan(wifiList: listTosend)
        
        
        wifiVC.ssidList = listTosend
        present(wifiVC, animated: true, completion: nil)
        //performSegue(withIdentifier: "MainNavToList", sender: sender)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //On load, hide the wifiScanButton
        wifiScanButton.isHidden = true
    }
    
    func createArray () -> [Ssid]{
        var tempssid: [Ssid] = []
        
        let ssid1 = Ssid(image: #imageLiteral(resourceName: "one_bar"), id: "foritnet_safe1")
        let ssid2 = Ssid(image:#imageLiteral(resourceName: "wifi_2bar"), id: "foritnet_safe2")
        let ssid3 = Ssid(image:#imageLiteral(resourceName: "wifi_3bar"), id: "foritnet_safe3")
        
        tempssid.append (ssid1)
        tempssid.append(ssid2)
        tempssid.append(ssid3)
        return tempssid
    }

}
