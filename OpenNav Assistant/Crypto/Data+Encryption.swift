//
//  Data+Encryption.swift
//  OpenNav Assistant
//
//  Created by Sylvan Martin on 3/17/19.
//  Copyright © 2019 Sylvan Martin. All rights reserved.
//

import Foundation
import CryptoSwift

extension Data {
    
    /// Encrypts a data object
    ///
    /// - Parameters:
    ///     - keyString: Key for data
    ///     - ivString: Initialization vector
    ///
    /// - Returns: Encrypted Data
    func encrypt(key keyString: String, iv ivString: String) -> Data? {
        let key = keyString.bytes
        let iv  = ivString.bytes
        
        do {
            let cbc = CBC(iv: iv)
            let aes = try AES(key: key, blockMode: cbc)
        
            let encryptedBytes = try aes.encrypt(self.bytes)
            let encryptedData  = Data(bytes: encryptedBytes)
            
            return encryptedData
        } catch {
            return nil
        }
        
    }
    
    /// Decrypts a data object
    ///
    /// - Parameters:
    ///     - keyString: Key for data
    ///     - ivString: Initialization vector
    ///
    /// - Returns: Decrypted Data
    func decrypt(key keyString: String, iv ivString: String) -> Data? {
        let key = keyString.bytes
        let iv  = ivString.bytes
        
        do {
            let cbc = CBC(iv: iv)
            let aes = try AES(key: key, blockMode: cbc)
        
            let decryptedBytes = try aes.decrypt(self.bytes)
            let decryptedData  = Data(bytes: decryptedBytes)
            
            return decryptedData
        } catch {
            return nil
        }
        
    }
    
}
