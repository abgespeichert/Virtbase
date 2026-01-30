//
//  KeychainModel.swift
//  Virtbase
//
//  Created by Karl Ehrlich on 30.01.26.
//

import Foundation
import Security

enum KeychainError: Error {
    // who knows
    case unknown
    
    // data fucked for some reason
    // doubt will ever happen
    case corrupted
    
    // read, before initial write was called
    case empty
}

final class KeychainModel {
    static let shared = KeychainModel()
    
    private let service = "com.virtbase.Virtbase"
    private let account = "com.virtbase.Session"
    
    // in-memory cache for the token
    // so we dont have to query
    // the keychain every single time
    // clears on crash or restart
    private var cachedToken: String?
    private let cacheLock = NSLock()
    
    private init() {}
    
    // write the token to the keychain
    // we could use userdefaults
    // however defaults are unsafe!!!
    func write(
        token: String
    ) throws {
        guard let data = token.data(using: .utf8) else {
            throw KeychainError.corrupted
        }
        
        // build the full keychain query
        // we must pass our service, and the account
        // its like saving a password
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        
        // delete the item first
        // otherwise it will crash
        // for some reason
        SecItemDelete(query as CFDictionary)
        
        // then add the query
        // also make the data only accessible
        // if the device is unlocked
        var addQuery = query
        addQuery[kSecValueData as String] = data
        addQuery[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlock
        
        let status = SecItemAdd(addQuery as CFDictionary, nil)
        
        // should be pretty obvios
        if status != errSecSuccess {
            throw KeychainError.unknown
        }
        
        // update the cache after successful write
        cacheLock.lock()
        cachedToken = token
        cacheLock.unlock()
    }
    
    func read() throws -> String {
        // check cache first
        cacheLock.lock()
        if let cached = cachedToken {
            cacheLock.unlock()
            return cached
        }
        cacheLock.unlock()
        
        // reconstruct our query with
        // service and account, so
        // we can read the "password"
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecItemNotFound {
            throw KeychainError.empty
        }
        
        if status != errSecSuccess {
            throw KeychainError.unknown
        }
        
        guard let data = result as? Data,
              let token = String(data: data, encoding: .utf8) else {
            throw KeychainError.corrupted
        }
        
        // cache the token after successful read
        cacheLock.lock()
        cachedToken = token
        cacheLock.unlock()
        
        return token
    }
    
    // delete the entry
    // this could be useful for
    // signing out or something
    func clear() throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        if status != errSecSuccess && status != errSecItemNotFound {
            throw KeychainError.unknown
        }
        
        // clear the cache after successful deletion
        cacheLock.lock()
        cachedToken = nil
        cacheLock.unlock()
    }
}
