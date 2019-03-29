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
    
    let manager = Alamofire.SessionManager.default

    /// Layouts URL
    let baseUrlString = "https://navdataservice.000webhostapp.com/layouts.php?f="
    
    /// URL For editors
    let editorURL     = "https://navdataservice.000webhostapp.com/editors.php?"
    
    // MARK: Methods
    
    // MARK: - Uploading Layouts
    
    func delete(layout: String, withTimeOut timeOut: Double = 60.0) {}
    
    func uploadLayout(_ layout: LayoutRequest, withTimeOut timeOut: Double = 60.0) {
        
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            let alert = NSAlert()
            alert.messageText = "You are not logged in!"
            alert.runModal()
            return
        }
        
        guard let password = UserDefaults.standard.string(forKey: "password") else {
            let alert = NSAlert()
            alert.messageText = "You are not logged in!"
            alert.runModal()
            return
        }
        
        manager.session.configuration.timeoutIntervalForRequest  = TimeInterval(timeOut)
        manager.session.configuration.timeoutIntervalForResource = TimeInterval(timeOut)
        
        // make URL for adding code
        let code          = layout.code
        var requestString = baseUrlString + "u&c=" + code.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        requestString    += "&u="    + username.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)! 
        requestString    += "&pass=" + password.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
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
                
                upload.responseString { response in
                    if let result = response.result.value {
                        print("Response:", result)
                    }
                }
            case .failure(_):
                print("FAIL")
                let alert = NSAlert()
                alert.messageText = "Check internet connection"
            }
        })
    }
    
    // MARK: - Accounts
    
    func createAccount(username: String, password: String, completion: @escaping (String) -> ()) {
        let arguments: [String : String] = [
            "f": "a",
            "u": username.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? username,
            "pass": password.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? password
        ]
        
        runAccountFunction(arguments: arguments) { (response) in
            print("Response on creating account:\n\(response)")
            completion(response)
        }
    }
    
    func verifyAccount(username: String, password: String, completion: @escaping (Bool) -> ()) {
        let arguments: [String : String] = [
            "f": "v",
            "u": username.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? username,
            "pass": password.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? password.hash
        ]
        
        runAccountFunction(arguments: arguments) { response in
            switch response {
            case "1":
                completion(true)
            default:
                print("Response on login:\n\(response)")
                completion(false)
            }
        }
    }
    
    func runAccountFunction(arguments: [String : String], completion: @escaping (String) -> ()) {
        var urlString = editorURL
        
        for arg in 0..<arguments.count {
            
            let isLastArg = arg == arguments.count - 1
            let key = Array(arguments.keys)[arg]
            urlString += "\(key)=\(arguments[key]!)"
            
            if !isLastArg {
                urlString += "&"
            }
        }
        
        let url = URL(string: urlString)!
        
        manager.request(url).responseString { response in
            if let string = response.result.value {
                completion(string)
            } else {
                completion("no response")
            }
        }
    }
}
