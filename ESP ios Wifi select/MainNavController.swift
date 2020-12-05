//
//  MainNavController.swift
//  ESP ios Wifi select
//
//  Created by Hanxiang Chen on 2018-10-31.
//  Copyright © 2018 Haxen Tech. All rights reserved.
// Wishlist Nov 8:
// implement dismess or back function for password selection screen, or go back to first controller to report connection extabilished 

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
    @IBOutlet weak var instruction: UITextView!
    
    // First button press, send user connect to esp32 wifi AP
    @IBAction func connectDidTap(_ sender: Any) {
        UIApplication.shared.open(URL(string:"App-Prefs:root=WIFI")!)
        
        //hide initiConnButton and show WifiScan button
        initiConnButton.isHidden = true
        wifiScanButton.isHidden = false
        instruction.text = "Click the button below to commond esp32 to start Wifi scan"
    
    }
    
    @IBAction func wifiScanDidTap(_ sender: Any) {
        print("wifi scan started")
        let esp32 = socketComm()
        let tempssidstruct = esp32.wifiScan()
        print("tempssidstruct : \(tempssidstruct)")
        //prepare sample ssid and wifi image
        //let listTosend = createArray()
        let listTosend = processWifiStruc(wifilist: tempssidstruct)
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
    
    func processWifiStruc (wifilist:[WIFIinfo]) -> [Ssid]{
        let tempstruc = wifilist
        var tempssid: [Ssid] = []
        var ssid_temp = Ssid(image: #imageLiteral(resourceName: "one_bar"), id: "nil")
        for stn in tempstruc {
            let signal_strength = Int(stn.RSSI)!
            if signal_strength >  -60{
                 ssid_temp = Ssid(image: #imageLiteral(resourceName: "wifi_3bar") , id: stn.SSID)
            }
            else if signal_strength <= -60 && signal_strength > -80 {
                 ssid_temp = Ssid(image: #imageLiteral(resourceName: "wifi_2bar") , id: stn.SSID)
            }
            else{
                 ssid_temp = Ssid(image: #imageLiteral(resourceName: "one_bar") , id: stn.SSID)
            }
            tempssid.append(ssid_temp)
        }
        return tempssid
    }
    
    @IBAction func restartFromBegin (_ sender: UIStoryboardSegue ){}

}
