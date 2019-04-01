//
//  Notification+Activity.swift
//  OpenNav Assistant
//
//  Created by Sylvan Martin on 3/30/19.
//  Copyright © 2019 Sylvan Martin. All rights reserved.
//

import Foundation

// public notification center object
let notificationCenter = NotificationCenter.default

extension Notification {
    static let startActivity = Notification(name: .init("startActivity"))
    static let stopActivity  = Notification(name: .init("stopActivity"))
    
    static let directoryURLSet = Notification(name: .init("directory_url_set"))
    
    static let beginUpload = Notification(name: .init("begin_upload"))
    
    static let newFileToView = Notification(name: .init("open_new_file"))
}
