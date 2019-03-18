//
//  ServerCommunicator.swift
//  OpenNav Assistant
//
//  Created by Sylvan Martin on 3/17/19.
//  Copyright © 2019 Sylvan Martin. All rights reserved.
//

import Foundation
import Alamofire

/// Communicates with database
class ServerCommunicator {
    
    // MARK: Properties

    /// Layouts URL
    let baseUrlString = "https://navdataservice.000webhostapp.com/layouts/layouts.php?f="
    
    // MARK: Methods
    
    func uploadLayout(_ layout: LayoutRequest, withTimeOut timeOut: Double = 60.0) {
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest  = TimeInterval(timeOut)
        manager.session.configuration.timeoutIntervalForResource = TimeInterval(timeOut)
        
        // make URL for adding code
        let code    = layout.code
        let codeURL = URL(string: (baseUrlString + "addcode&code=" + code))!
        print("Code URL:", codeURL)
        
        // get crypto info
        let key = layout.cryptoInfo["key"]!
        let iv  = layout.cryptoInfo["iv"]!
        
        // upload the code
        manager.request(codeURL).responseData { response in
            // the code has been added, now upload other properties
            let arguments = layout.getURLArguments()
            
            for (tag, property) in arguments {
                
                // encrypt whatever it is
                let data = property.data(using: .utf8)!
                let encryptedData = data.encrypt(key: key, iv: iv)!
                let encryptedProperty = String(data: encryptedData, encoding: .ascii)!
                
                // images will be dealt with separately.
                if tag != "images" {
                    
                    var requestURLString = self.baseUrlString + "add" + tag + "&code=" + code
                    requestURLString += "&" + tag + "=" + encryptedProperty
                    
                    let url = URL(string: requestURLString)!
                    
                    print("Requesting:", url)
                    manager.request(url).responseData(completionHandler: { response in
                        print("Response for \(url):\n", response)
                    })
                    
                    return
                }
                
                // now send the images
                
            }
        }
        
    }
    
    
}
