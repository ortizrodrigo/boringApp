//
//  KeychainHandler.swift
//  boringApp
//
//  Created by Rodrigo Ortiz on 23/09/24.
//

import Foundation
import Security

struct KeychainHandler {
    
    enum SaltGenerationError: Error {
        case saltGenerationFailed
    }
    
    enum PasswordHashingError: Error {
        case passwordHashingFailed
    }
    
    static func genSalt() -> Data? {
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
            print("Failed to generate salt")
            return nil
        }
        
        return salt
    }
    
    static func hashPassword(password: String, withSalt salt: Data) -> Data? {
        // Convert password: String to passwordData: Data
        guard let passwordData = password.data(using: .utf8) else {
            print("Failed to convert password to Data object")
            return nil
        }
        
        // Hash the password
        var hash = [UInt8](repeating: 0, count: 32)
        let hashLength = 32 // Change this based on your needs
        
        
    }
    
    static func storePassword(username: String, password: String) {
        
    }
    
    static func retrievePassword(username: String) {
        
    }
}

