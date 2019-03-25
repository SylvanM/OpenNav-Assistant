//
//  Global.swift
//  OpenNav Assistant
//
//  Created by Sylvan Martin on 3/22/19.
//  Copyright © 2019 Sylvan Martin. All rights reserved.
//

import Foundation

/// made so that a loading bar can access how far the upload is

public var fragmentsSent: Int = 0 {
    didSet {
        NotificationCenter.default.post(name: .uploadedImageFragment, object: nil)
    }
}

public var totalFragments: Int = 1

public var percentImageFragmentsSent: Double {
    return Double(fragmentsSent / totalFragments)
}
