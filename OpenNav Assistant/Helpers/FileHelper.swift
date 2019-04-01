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
    
    func getLayout() throws -> LayoutRequest {
        var request: LayoutRequest
        
        // first, get the code
        var code: String
        
        do {
            code = try String(contentsOf: directory.appendingPathComponent("code", isDirectory: false))
        } catch {
            throw FileError.noCode
        }
        
        request = LayoutRequest(code: code, properties: [:])
        
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
    
    // Returns a the code, and a list of file names along with their URL
    func getFiles() throws -> (String, [(String, URL)])? {
        
        var returnValue: (String, [(String, URL)])? = nil
        var code: String
        
        do {
            code = try String(contentsOf: directory.appendingPathComponent("code", isDirectory: false))
        } catch {
            throw FileError.noCode
        }
        
        returnValue = (code, [])
        
        if let enumerator = FileManager.default.enumerator(atPath: self.directory.path) {
            while let element = enumerator.nextObject() as? String {
                if element != ".DS_Store" && element != "code" {
                    let fileToAppend = ((element as NSString).deletingPathExtension, self.directory.appendingPathComponent(element))
                    returnValue?.1.append(fileToAppend)
                }
            }
        }
        
        return returnValue
        
    }
    
    func extractImages() -> [String : Image] {
        var fileNames: [String] = []
        var images: [String : NSImage] = [:]
        let fileManager = FileManager.default
        
        // loop through all files in directory
        if let enumerator = fileManager.enumerator(atPath: self.directory.path) {
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
    
    enum FileError: String, Error {
        case noCode = "There was no file with a suitable code found in the directory"
    }
    
}
