//
//  wificell.swift
//  wifilistTableview
//
//  Created by Hanxiang Chen on 2018-10-17.
//  Copyright © 2018 Haxen Tech. All rights reserved.
//

import UIKit

class wificell: UITableViewCell {
    
    @IBOutlet weak var wifiImage: UIImageView!
    @IBOutlet weak var ssidText: UILabel!
    
    func setSSID (ssid:Ssid){
        wifiImage.image = ssid.image
        ssidText.text = ssid.id
    }

}
