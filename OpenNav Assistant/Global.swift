//
//  Global.swift
//  OpenNav Assistant
//
//  Created by Sylvan Martin on 3/22/19.
//  Copyright © 2019 Sylvan Martin. All rights reserved.
//

import Foundation

/// Contains constants for keys for the global dictionary
enum GlobalKey: String {
    case layoutDir = "layout_directory"
}

var layoutCode: String? {
    do {
        guard let url = directory else { return nil }
        return try FileHelper(url).getFiles()?.0
    } catch {
        return nil
    }
}

var directory: URL? = UserDefaults.standard.url(forKey: GlobalKey.layoutDir.rawValue) {
    didSet {
        UserDefaults.standard.set(directory, forKey: GlobalKey.layoutDir.rawValue)
        notificationCenter.post(.directoryURLSet)
        
        
        
    }
}
