//
//  KeychainHandler.swift
//  boringApp
//
//  Created by Rodrigo Ortiz on 23/09/24.
//

import Foundation
import Security

struct KeychainHandler {
    
    static func generateSalt() -> Data? {
        let bytes = 16 // Immutable
        var salt = Data(count: bytes) // Create Data object for salt
        
        // Fill the salt Data object with random bytes
        let genStatus = salt.withUnsafeMutableBytes {
            SecRandomCopyBytes(kSecRandomDefault, bytes, $0.baseAddress!)
        }
        
        // Check the success of the random byte generation
        if genStatus == errSecSuccess {
            return salt
        } else {
            print("There was a problem generating the salt")
            return nil
        }
        
        return salt
    }
    
    static func storePassword(username: String, password: String) {
        
    }
    
    static func retrievePassword(username: String) {
        
    }
}

