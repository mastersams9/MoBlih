//
//  KeychainWrapper.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 09/05/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

protocol KeychainWrapperInput: class
{
    func save(accessToken: String, accountName: String) throws
    func findPassword() throws -> String?
    func findUsername() -> String?
    func deletePassword() throws
}

enum KeychainWrapperError: Error
{
    case noCurrentAccountNameFound
}

class KeychainWrapper: KeychainWrapperInput
{
    // MARK: - Property
    
    let userDefault = UserDefaults.standard
    
    // MARK: - Enums
    
    enum Constants {
        static let accountNameKey = "currentAccountName"
    }
    
    func save(accessToken: String, accountName: String) throws {
        // This is a new account, create a new keychain item with the account name.
        
        userDefault.set(accountName, forKey: Constants.accountNameKey)
        userDefault.synchronize()
        
        let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: accountName, accessGroup: KeychainConfiguration.accessGroup)
        
        // Save the password for the new item.
        try passwordItem.savePassword(accessToken)
    }
    
    func findPassword() throws -> String? {
        guard let accountName = userDefault.string(forKey: Constants.accountNameKey) else { return nil }
        return try? KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: accountName, accessGroup: KeychainConfiguration.accessGroup).readPassword()
    }
    
    func findUsername() -> String? {
        guard let accountName = userDefault.string(forKey: Constants.accountNameKey) else { return nil }
        return accountName
    }
    
    func deletePassword() throws {
        guard let accountName = userDefault.string(forKey: Constants.accountNameKey) else { throw KeychainWrapperError.noCurrentAccountNameFound }
        try KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: accountName, accessGroup: KeychainConfiguration.accessGroup).deleteItem()
        userDefault.removeObject(forKey: Constants.accountNameKey)
        userDefault.synchronize()
    }
}
