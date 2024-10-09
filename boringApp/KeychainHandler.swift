//
//  KeychainHandler.swift
//  boringApp
//
//  Created by Rodrigo Ortiz on 23/09/24.
//

import Foundation
import Security

struct KeychainHandler {
    
    enum KeychainError: Error {
        case saltGenerationFailed
        case storeFailed
        case retrieveFailed
        case dataConversionFailed
        case hashingFailed
        case verificationFailed
    }
    
    static func genSalt() -> (Data?, KeychainError?) {
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
    
    static func hashPassword(password: String, withSalt salt: Data) -> (Data?, KeychainError?) {
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
    
    static func storeCredentials(username: String, password: String) -> KeychainError? {
        // Generate a salt
        let saltResult = genSalt()
        guard let salt = saltResult.0, saltResult.1 == nil else {
            return .saltGenerationFailed
        }
        
        // Hash the password with the salt
        let hashResult = hashPassword(password: password, withSalt: salt)
        guard let hashedPassword = hashResult.0, hashResult.1 == nil else {
            return .hashingFailed
        }
        
        // Store the salt, hashed password, and username in the Keychain
        let combinedData = salt + hashedPassword
        
        let keychainQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: username,
            kSecValueData as String: combinedData
        ]
        
        let status = SecItemAdd(keychainQuery as CFDictionary, nil)
        
        if status != errSecSuccess {
            return .storeFailed
        }
        
        return nil
    }
    
    // Retrieve and verify credentials
    static func verifyCredentials(username: String, password: String) -> (Bool, KeychainError?) {
        let keychainQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: username,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var retrievedData: AnyObject?
        let status = SecItemCopyMatching(keychainQuery as CFDictionary, &retrievedData)
        
        if status != errSecSuccess {
            return (false, .retrieveFailed)
        }
        
        guard let storedData = retrievedData as? Data else {
            return (false, .retrieveFailed)
        }
        
        // Split the stored data into salt and hashed password
        let salt = storedData.prefix(16) // First 16 bytes are the salt
        let storedHash = storedData.suffix(from: 16) // Remaining bytes are the hashed password
        
        // Hash the provided password with the stored salt
        let hashResult = hashPassword(password: password, withSalt: salt)
        guard let hashedPassword = hashResult.0, hashResult.1 == nil else {
            return (false, .hashingFailed)
        }
        
        // Compare the hashes
        if hashedPassword != storedHash {
            return (false, .verificationFailed)
        }
        return (true, nil)
    }
}

