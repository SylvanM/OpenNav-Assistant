//
//  FileHelper.swift
//  OpenNav Assistant
//
//  Created by Sylvan Martin on 3/17/19.
//  Copyright © 2019 Sylvan Martin. All rights reserved.
//

import Foundation
import SwiftyJSON

/// Helps with gathering a layout from a directory
class FileHelper {
    
    // MARK: Properties
    
    /// Layout directory
    var directory: URL
    
    // MARK: Initializers
    
    /// Initializes class with a directory
    ///
    /// - Parameters:
    ///     - directory: URL of the directory from which to extract the layout
    init(_ directory: URL) {
        self.directory = directory
    }
    
    // MARK: Methods
    
    func getLayout() -> LayoutRequest? {
        var request: LayoutRequest
        
        // first, get the code
        var code: String
        
        do {
            code = try String(contentsOf: directory.appendingPathComponent("code", isDirectory: false))
        } catch {
            print("Error on getting code:", error)
            return nil
        }
        
        // now get the crypto info
        var cryptoInfo: [String : String]
        
        do {
            let cryptoData = try Data(contentsOf: directory.appendingPathComponent("crypto.json"))
            let cryptoJSON = try JSON(data: cryptoData)
            cryptoInfo = cryptoJSON.dictionaryObject as! [String : String]
        } catch {
            print("Error on getting crypto:", error)
            return nil
        }
        
        request = LayoutRequest(code: code, cryptoInfo: cryptoInfo, properties: [:])
        
        // now get the rest of the properties. these are all optional
        
        // get info
        var info: [String : Any]? = nil
        
        do {
            let infoData = try Data(contentsOf: directory.appendingPathComponent("info.json"))
            let infoJSON = try JSON(data: infoData)
            info = infoJSON.dictionaryObject
            print("Gathered info:", info as Any)
        } catch {
            print("Error getting info:", error)
        }
        
        // get layout
        var layout: [[[String]]]? = nil
        
        do {
            let layoutData = try Data(contentsOf: directory.appendingPathComponent("layout.json"))
            let layoutJSON = try JSON(data: layoutData)
            layout = layoutJSON.arrayObject as? [[[String]]]
            print("Gathered layout:", layout as Any)
        } catch {
            print("Error getting layout:", error)
        }
        
        // get rooms
        var rooms: [String : [Int]]? = nil
        
        do {
            let roomsData = try Data(contentsOf: directory.appendingPathComponent("rooms.json"))
            let roomsJSON = try JSON(data: roomsData)
            rooms = roomsJSON.dictionaryObject as? [String : [Int]]
            print("Gathered rooms:", rooms as Any)
        } catch {
            print("Error getting rooms:", error)
        }
        
        // get images
        let images = extractImages()
        
        // now set properties
        request.properties[.images] = images
        request.properties[.info]   = info
        request.properties[.layout] = layout
        request.properties[.rooms]  = rooms
        
        return request
    }
    
    func extractImages() -> [String : Image] {
        var fileNames: [String] = []
        var images: [String : NSImage] = [:]
        let fileManager = FileManager.default
        
        // loop through all files in directory
        if let enumerator = fileManager.enumerator(atPath: directory.path) {
            while let element = enumerator.nextObject() as? String {
                if element.hasSuffix("png") { // checks the extension
                    fileNames.append(element)
                }
            }
        }
        
        for file in fileNames {
            
            let imageName = (file as NSString).deletingPathExtension
            print("Image name: ", imageName)
            
            images[imageName] = Image(contentsOf: URL(fileURLWithPath: directory.appendingPathComponent(file).path))
        }
        
        return images
    }
    
}
