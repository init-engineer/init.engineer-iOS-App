//
//  KeyChainManager.swift
//  init.engineer-iOS-App
//
//  Created by horo on 1/17/21.
//

import Foundation
import KeychainAccess

class KeyChainManager {
    static let shared = KeyChainManager()
    private var token: String?
    private let serviceName = K.getInfoPlistByKey("Keychain Service Name")!
    
    // TODO: Add passcode/biometry lock
    // Can refer from :https://cocoapods.org/pods/KeychainAccess
    
    func saveToken(_ token: String) {
        let key = Keychain(service: serviceName)
        self.token = token
        key["token"] = token
    }
    
    func getToken() -> String? {
        if self.token == nil {
            let key = Keychain(service: serviceName)
            self.token = key["token"]
        }
        
        return self.token
    }
    
    func deleteToken() {
        self.token = nil
        let key = Keychain(service: serviceName)
        key["token"] = nil
    }
}
