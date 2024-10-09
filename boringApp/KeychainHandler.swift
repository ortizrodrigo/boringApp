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
        case dataConversionFailed
        case hashingFailed
    }
    
    static func genSalt() -> (Data?, SaltGenerationError?) {
        let bytes = 16 // Immutable
        var salt = Data(count: bytes) // Create Data object for salt
        
        // Fill the salt Data object with random bytes
        let genStatus = salt.withUnsafeMutableBytes {
            SecRandomCopyBytes(kSecRandomDefault, bytes, $0.baseAddress!)
        }
        
        // Check the success of the random byte generation
        if genStatus != errSecSuccess {
            print("Failed to generate salt")
            return (nil, .saltGenerationFailed)
        }
        
        return (salt, nil)
    }
    
    static func hashPassword(password: String, withSalt salt: Data) -> (Data?, PasswordHashingError?) {
        // Convert the password to Data
        guard let passwordData = password.data(using: .utf8) else {
            return (nil, .dataConversionFailed)
        }
        
        // Fixed output size: 32 bytes (256 bits)
        let outputSize = 32
        var hash = Data(count: outputSize)
        
        // Use Argon2 to hash the password
        let result = hash.withUnsafeMutableBytes { outputPtr in
            passwordData.withUnsafeBytes { passwordPtr in
                salt.withUnsafeBytes { saltPtr in
                    argon2i_hash_raw(
                        2,  // Number of iterations
                        1 << 16,  // Memory usage (64 MiB)
                        1,  // Parallelism (1 thread)
                        passwordPtr.baseAddress!, passwordData.count,
                        saltPtr.baseAddress!, salt.count,
                        outputPtr.baseAddress!, outputSize
                    )
                }
            }
        }
        
        // Compare the result using rawValue of Argon2_ErrorCodes
        if result != ARGON2_OK.rawValue {
            return (nil, .hashingFailed)
        }
        
        return (hash, nil)
    }
    
    static func storePassword(username: String, password: String) {
        
    }
    
    static func retrievePassword(username: String) {
        
    }
}

