//
//  KeychainHandler.swift
//  boringApp
//
//  Created by Rodrigo Ortiz on 23/09/24.
//

import Foundation
import Security
import CryptoKit

struct KeychainHandler {
    
    enum SaltGenerationError: Error {
        case saltGenerationFailed
    }
    
    enum PasswordHashingError: Error {
        case dataConversionFailed
        case hashingFailed
    }
    
    enum KeychainError: Error {
        case storageFailed
        case retrievalFailed
        case verificationFailed
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
    
    static func hashPassword(password: String, salt: Data) -> Data? {
        guard let passwordData = password.data(using: .utf8) else {
            return nil
        }
        
        let hashed = HKDF<SHA256>.deriveKey(
            inputKeyMaterial: SymmetricKey(data: passwordData),
            salt: salt,
            info: Data(),
            outputByteCount: 32 // 256-bit output
        )
        
        return hashed.withUnsafeBytes { bytes in
            return Data(bytes)
        }
    }
    
    static func storeCredentials(username: String, password: String) -> KeychainError? {
        // Generate a salt
        let saltResult = genSalt()
        guard let salt = saltResult.0, saltResult.1 == nil else {
            return .storageFailed
        }
        
        // Hash the password with the salt using CryptoKit
        guard let hashedPassword = hashPassword(password: password, salt: salt) else {
            return .storageFailed
        }
        
        // Store salt and hashed password in Keychain
        let saltKey = "\(username)_salt"
        let hashKey = "\(username)_hash"
        
        let saltStatus = storeToKeychain(key: saltKey, data: salt)
        let hashStatus = storeToKeychain(key: hashKey, data: hashedPassword)
        
        if saltStatus != errSecSuccess || hashStatus != errSecSuccess {
            return .storageFailed
        }
        
        return nil // Success
    }

    
    static func verifyCredentials(username: String, password: String) -> (Bool, KeychainError?) {
        let saltKey = "\(username)_salt"
        let hashKey = "\(username)_hash"
        
        // retrieve storedSalt
        guard let storedSalt = retrieveFromKeychain(key: saltKey),
              let storedHash = retrieveFromKeychain(key: hashKey) else {
            return (false, .retrievalFailed)
        }
        
        // Hash the password with the salt using CryptoKit
        guard let hashedPassword = hashPassword(password: password, salt: storedSalt) else {
            return (false, .verificationFailed)
        }
        
        // Use constant-time comparison to avoid timing attacks
        if !constantTimeCompare(hashedPassword, storedHash) {
            return (false, .verificationFailed)
        }
        
        return (true, nil) // Success
    }
    
    static func userExists(username: String) -> Bool {
        let saltKey = "\(username)_salt"
        
        // Attempt to retrieve the user's salt from the Keychain
        if let _ = retrieveFromKeychain(key: saltKey) {
            return true
        } else {
            return false
        }
    }
    
    private static func storeToKeychain(key: String, data: Data) -> OSStatus {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        // Add or update the item
        SecItemDelete(query as CFDictionary)
        return SecItemAdd(query as CFDictionary, nil)
    }
    
    // Helper to retrieve data from Keychain
    private static func retrieveFromKeychain(key: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecSuccess, let data = result as? Data {
            return data
        }
        
        return nil
    }
    
    private static func constantTimeCompare(_ data1: Data, _ data2: Data) -> Bool {
        guard data1.count == data2.count else {
            return false
        }
        
        var result: UInt8 = 0
        for i in 0..<data1.count {
            result |= data1[i] ^ data2[i]
        }
        return result == 0
    }
    
}

