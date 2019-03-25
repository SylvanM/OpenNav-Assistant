//
//  ServerCommunicator.swift
//  OpenNav Assistant
//
//  Created by Sylvan Martin on 3/17/19.
//  Copyright © 2019 Sylvan Martin. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

/// Communicates with database
class ServerCommunicator {
    
    // MARK: Properties

    /// Layouts URL
    let baseUrlString = "https://navdataservice.000webhostapp.com/layouts.php?f="
    
    // MARK: Methods
    
    func delete(layout: String, withTimeOut timeOut: Double = 60.0) {
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest  = TimeInterval(timeOut)
        manager.session.configuration.timeoutIntervalForResource = TimeInterval(timeOut)
        
        let url = URL(string: baseUrlString + "removeLayout&code=" + layout)!
        print("Deleting:", url)
        manager.request(url)
    }
    
    func uploadLayout(_ layout: LayoutRequest, withTimeOut timeOut: Double = 60.0) {
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest  = TimeInterval(timeOut)
        manager.session.configuration.timeoutIntervalForResource = TimeInterval(timeOut)
        
        // make URL for adding code
        let code          = layout.code
        let requestString = baseUrlString + "u&c=" + code.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let url           = URL(string: requestString)!
        
        let arguments = layout.getDatas()
        
        manager.upload(multipartFormData: { multipartFormData in
            if let layoutData = arguments["layout"] { multipartFormData.append(layoutData.base64EncodedData(), withName: "l", fileName: "layout.json", mimeType: "application/json") }
            if let roomsData  = arguments["rooms"]  { multipartFormData.append(roomsData.base64EncodedData(),  withName: "r", fileName: "rooms.json",  mimeType: "application/json") }
            if let infoData   = arguments["info"]   { multipartFormData.append(infoData.base64EncodedData(),   withName: "e", fileName: "info.json",   mimeType: "application/json") }
            if let imageData  = arguments["images"] { multipartFormData.append(imageData.base64EncodedData(),  withName: "i", fileName: "images.json", mimeType: "application/json") }
        }, to: url, encodingCompletion: { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    print("\nResponse for upload:\n", String(data: response.data!, encoding: .ascii)!, "\n\n")
                }
            case .failure(_):
                print("FAIL")
            }
        })
        
    }
}
