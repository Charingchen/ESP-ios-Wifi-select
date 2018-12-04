//
//  SocketCom.swift
//  ESP ios Wifi select
//
//  Created by Hanxiang Chen on 2018-11-20.
//  Copyright © 2018 Haxen Tech. All rights reserved.
//

import Foundation
import SwiftSocket

struct WIFIinfo{
    let SSID: String
    let RSSI: String
    let AUTH: String
}

class socketComm {
    let sendGood = "CMD received!"
    let sendBad = "Got NO CMD!"
    let startScan = "c1"
    let enableTx = "c2"
    let sendPswd = "c3"
    let client = TCPClient(address: "192.168.1.1", port: 100)
    
    public func wifiScan() -> [WIFIinfo]{
        var dataRecv = sendCmd(cmd: startScan)
        print(dataRecv)
        dataRecv = sendCmd(cmd: enableTx)
        print("dataRecv:\(dataRecv)")
//        let dataRecv: String = "3#SSID:fortinet. RSSI:-40. Authmode: unknown.\nSSID:wiiwl. RSSI:-68. Authmode: WIFI_AUTH_WPA2_PSK.\nSSID:kkksi. RSSI:-78. Authmode: WIFI_AUTH_WPA2_PSK.\n"
        let wifiStruc = prepareSSIDlist(dataRecv: dataRecv)
        return wifiStruc
    }
    public func sendingPassword(password: String){
        let dataRecv = sendCmd(cmd: sendPswd + password)
        print("dataRecv:\(dataRecv)")
    }
    
    private func sendCmd (cmd: String) -> String{
        //assign it to nil for debugging purpose
        var dataread: String = "nil"
        switch client.connect(timeout: 10) {
            // first case of success + fail is for connection establishment
        case .success:
            print("Client Connect Succussful")
            switch client.send(string: cmd ) {
                //This determine if the sending is succussful
            case .success:
                print("Send request succussful")
                // Reading socket package of 1024 * 10, if there no data return the function right away. This is a less gracful way to achieve ACK
                guard let data = client.read(1024*10, timeout: 5) else { return "No data read" }
                
                if var response = String(bytes: data, encoding: .utf8) {
                    print("Response: \(response)")
                    dataread = response
                    //sendBad are sending from esp32, to indicate no cmd recieved.
                    if response == sendBad{
                        // if no ACK from esp32, try to spam the esp32 with the cmd until it ack
                        repeat{
                            print("Re-sending the command")
                            switch client.connect(timeout: 10) {
                            case .success:
                                print("Client Connect Succussful")
                                switch client.send(string: cmd ) {
                                case .success:
                                    print("Send request succussful")
                                    guard let data = client.read(1024*10, timeout: 5) else { return "No data read" }
                                    response = String(bytes: data, encoding: .utf8)!
                                case .failure(let error):
                                    print("send fail, error: \(error)")
                                    client.close()
                                }
                            case .failure(let error):
                                print("send fail, error: \(error)")
                            }
                        } while response == sendBad
                    }
                }
                return dataread
            case .failure(let error):
                print("send fail, error: \(error)")
                client.close()
            }
        case .failure(let error):
            print("Client connect failure, error: \(error)")
        }
        return "nil"
    }
    
    private func prepareSSIDlist (dataRecv: String) -> [WIFIinfo]{
        var ssidList = [String]()
        var wifilist = [WIFIinfo]()
        var rawdata: String = dataRecv
        let hashIndex = rawdata.index(before:rawdata.index(of:"#") ?? rawdata.endIndex)
        if let staNum = Int(String(rawdata[...hashIndex])){
            print("sta number rec:\(staNum)")
            rawdata.removeSubrange(rawdata.startIndex...rawdata.index(after: hashIndex))
            
            for i in 0..<staNum {
                let location = rawdata.index(after:rawdata.index(of:"\n") ?? rawdata.endIndex)
                let string1 = String(rawdata[..<location])
                ssidList.append(string1.replacingOccurrences(of: "\n", with: " "))
                rawdata.removeSubrange(rawdata.startIndex..<location)
                print("partial substring\(i):\(ssidList[i])")
                
            }
            for info in ssidList{
                //create a tempString varable to perform string manipulation
                var tempString = info
                var colonlocation = tempString.index(after:tempString.index(of:":") ?? tempString.endIndex)
                var dotlocation = tempString.index(before:tempString.index(of:".") ?? tempString.endIndex)
                let ssid = String(tempString[colonlocation...dotlocation])
                tempString.removeSubrange(tempString.startIndex...tempString.index(after: dotlocation))
                colonlocation = tempString.index(after:tempString.index(of:":") ?? tempString.endIndex)
                dotlocation = tempString.index(before:tempString.index(of:".") ?? tempString.endIndex)
                let rssi = String(tempString[colonlocation...dotlocation])
                tempString.removeSubrange(tempString.startIndex...tempString.index(after: dotlocation))
                colonlocation = tempString.index(after:tempString.index(of:":") ?? tempString.endIndex)
                dotlocation = tempString.index(before:tempString.index(of:".") ?? tempString.endIndex)
                let auth = String(tempString[colonlocation...dotlocation])
                let newinfo = WIFIinfo(SSID: ssid, RSSI: rssi, AUTH: auth)
                wifilist.append(newinfo)
            }
        }
        print("ssidList: \(ssidList)")
        print("wifilist: \(wifilist)")
        return wifilist
    }
}

extension String {
    var length: Int {
        return self.count
    }
    
    func indices(of occurrence: String) -> [Int] {
        var indices = [Int]()
        var position = startIndex
        while let range = range(of: occurrence, range: position..<endIndex) {
            let i = distance(from: startIndex,
                             to: range.lowerBound)
            indices.append(i)
            let offset = occurrence.distance(from: occurrence.startIndex,
                                             to: occurrence.endIndex) - 1
            guard let after = index(range.lowerBound,
                                    offsetBy: offset,
                                    limitedBy: endIndex) else {
                                        break
            }
            position = index(after: after)
        }
        return indices
    }
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
    func index(at offset: Int) -> String.Index {
        return index(startIndex, offsetBy: offset)
    }
    //    subscript (inttoindex: Int) -> String.Index {
    //        let charIndex = self.index(self.startIndex, offsetBy: inttoindex)
    //        return charIndex
    //    }
}
