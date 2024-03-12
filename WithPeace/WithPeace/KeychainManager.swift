//
//  KeychainManager.swift
//  WithPeace
//
//  Created by Hemg on 3/8/24.
//

import Foundation

final class KeychainManager {
    enum KeychainError: Error {
        case duplicateEntry
        case unkown(OSStatus)
    }
    
    //TODO: 키체인저장
    func save(account: String, password: Data) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecValueData as String: password,
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecDuplicateItem {
            try update(account: account, password: password)
            return
        }
        
        guard status == errSecSuccess else {
            throw KeychainError.unkown(status)
        }
        
        print("save")
    }
    
    //TODO: 이미 저장된 계정의 키체인 항목 업데이트를 하려고 할때 사용하면됨
    func update(account: String, password: Data) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
        ]
        
        let newQuery: [String: Any] = [
            kSecValueData as String: password,
        ]
        
        let status = SecItemUpdate(query as CFDictionary, newQuery as CFDictionary)
        
        guard status == errSecSuccess else {
            throw KeychainError.unkown(status)
        }
        
        print("update")
    }
    
    //TODO: 토큰 검색
    func get(account: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecSuccess, let attributes = result as? [String: Any],
           let passwordData = attributes[kSecValueData as String] as? Data {
            return passwordData
        }
        return nil
    }
    
    func delete(account: String) {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account as AnyObject,
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == errSecSuccess else {
            print("delete fail")
            return
        }
        
        print("delete success")
    }
}
