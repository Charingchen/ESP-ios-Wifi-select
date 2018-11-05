//
//  WifiListScreenViewController.swift
//  wifilistTableview
//
//  Created by Hanxiang Chen on 2018-10-17.
//  Copyright © 2018 Haxen Tech. All rights reserved.
//

import UIKit
//before I put this variable inside the viewcontroller class and it is called 4 times before delegation happened. and the after delegation happened, the class is been called again and re-inital ssidList to nil and then perform tableview. It crashed because the nil overwritten the delegate data
var ssidList: [Ssid]?

class WifiListScreenViewController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let mainNavVC = storyboard?.instantiateViewController(withIdentifier: "mainNav") as! MainNavController
        mainNavVC.wifidelegate = self
        tableview.delegate = self
        tableview.dataSource = self
        
    }

}

extension WifiListScreenViewController : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ssidList!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ssid = ssidList![indexPath.row]
        //Remeber to setup the Identifier at mainstory board under attribute inspector 
        let cell = tableView.dequeueReusableCell(withIdentifier: "wificell") as! wificell
        cell.setSSID(ssid: ssid)
        
        return cell
    }
    
    
}

extension WifiListScreenViewController :wifiInfoDelegate{
    func didTapWifiScan(wifiList: [Ssid]) {
        ssidList = wifiList
    }
   
}
