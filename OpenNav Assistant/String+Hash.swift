//
//  String+Hash.swift
//  OpenNav Assistant
//
//  Created by Sylvan Martin on 3/25/19.
//  Copyright © 2019 Sylvan Martin. All rights reserved.
//

import Foundation
import CommonCrypto

extension String {
    
    var hash: String {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA256), self, self.count, self, self.count, &digest)
        let data = Data(digest)
        return data.map { String(format: "%02hhx", $0) }.joined()
    }
    
}
