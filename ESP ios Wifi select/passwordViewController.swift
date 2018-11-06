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
    
    @IBOutlet weak var ssidTextField: UITextView!
    @IBOutlet weak var passwordEntered: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let wifiListVC = storyboard?.instantiateViewController(withIdentifier: "wifilistview") as! WifiListScreenViewController
        wifiListVC.ssidDelegate = self
        ssidTextField.text = ssid?.id
        
        passwordEntered.delegate = self
        passwordEntered.isSecureTextEntry = true
        
    }
    
    @IBAction func sendDidTap(_ sender: Any) {
        //initiate socket socket transfer
        print("Password input: \(passwordEntered.text!) for \(ssid!.id)")
    }
    
}

extension passwordViewController : ssidSelectDelegate, UITextFieldDelegate{
    func didTapSSID(ssidInfo: Ssid) {
        ssid = ssidInfo
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
