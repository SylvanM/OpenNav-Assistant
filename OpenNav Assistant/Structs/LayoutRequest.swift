//
//  LayoutRequest.swift
//  OpenNav Assistant
//
//  Created by Sylvan Martin on 3/17/19.
//  Copyright © 2019 Sylvan Martin. All rights reserved.
//

import Foundation
import SwiftyJSON

/// Represents a layout to upload
struct LayoutRequest {
    
    // MARK: Properties
    
    /// Code for layout
    var code: String
    
    /// Properties
    var properties: [LayoutProperty : Any]
    
    
    // MARK: Methods
    
    func getDatas() -> [String : Data] {
        
        var arguments: [String : Data] = [:]
        
        for key in LayoutProperty.allCases {
            if let property = properties[key] {
                
                // JSON object to turn into string
                var jsonObject: JSON!
                
                // Images are stored as [String : NSImage], so unwrap it as such, and convert it to a JSON,
                // which will be converted to a string
                if key == .images {
                    let imageDict = property as! [String : NSImage]
                    let imageJson = imageDict.mapValues { $0.png!.base64EncodedString() }
                    
                    jsonObject = JSON(imageJson)
                }
                    
                // Make a JSON out of the info, then convert it to a string
                else if key == .info {
                    let infoDict   = property as! [String : Any]
                    jsonObject     = JSON(infoDict)
                }
                
                // Unwrap layout as 3D array, convert it to JSON, then to string
                else if key == .layout {
                    let layout = property as! [[[String]]]
                    jsonObject = JSON(layout)
                }
                
                // Unwraps rooms as [String : [Int]], converts it to JSON, then to string
                else if key == .rooms {
                    let rooms  = property as! [String : [Int]]
                    jsonObject = JSON(rooms)
                }
                
        
                // Now set the string value to the arguments object
                do {
                    arguments[key.rawValue] = try jsonObject.rawData()
                } catch {
                    arguments[key.rawValue] = nil
                }
            }
        }
        
        return arguments
    }
    
    // MARK: Enumerations
    
    /// A layout property
    enum LayoutProperty: String, CaseIterable {
        case images = "images"
        case info   = "info"
        case layout = "layout"
        case rooms  = "rooms"
    }
    
}
