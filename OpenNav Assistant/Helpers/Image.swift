//
//  Image.swift
//  OpenNav Assistant
//
//  Created by Sylvan Martin on 3/17/19.
//  Copyright © 2019 Sylvan Martin. All rights reserved.
//

import Foundation
import Cocoa

public typealias Image = NSImage

extension NSBitmapImageRep {
    var png: Data? { // returns png data of bitmap data
        return representation(using: .png, properties: [:])
    }
}

extension Data {
    var bitmap: NSBitmapImageRep? { // returns bitmap representation of data
        return NSBitmapImageRep(data: self)
    }
}

extension Image {
    var png: Data? { // returns png data of an image
        return tiffRepresentation?.bitmap?.png
    }
}
