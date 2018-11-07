//
//  passwordViewController.swift
//  ESP ios Wifi select
//
//  Created by Hanxiang Chen on 2018-11-05.
//  Copyright © 2018 Haxen Tech. All rights reserved.
//

import UIKit

class passwordViewController: UIViewController {
    var wifiInfo: Ssid?
    @IBOutlet weak var ssidTextField: UITextView!
    @IBOutlet weak var passwordEntered: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ssidTextField.text = wifiInfo?.id
        
        passwordEntered.delegate = self
        passwordEntered.isSecureTextEntry = true
        
    }
    
    @IBAction func sendDidTap(_ sender: Any) {
        //initiate socket socket transfer
        print("Password input: \(passwordEntered.text!) for \(wifiInfo!.id)")
    }
    
}

extension passwordViewController : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
