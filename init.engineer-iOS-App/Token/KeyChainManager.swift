//
//  KeyChainManager.swift
//  init.engineer-iOS-App
//
//  Created by horo on 1/17/21.
//  Copyright © 2021 Kantai Developer. All rights reserved.
//

import Foundation
import KeychainAccess

class KeyChainManager {
    static let shared = KeyChainManager()
    private var token: String?
    private let serviceName = "kaobei" // This name should chance to a constant value in a secret constant file.
    
    // TODO: Add passcode/biometry lock
    // Can refer from :https://cocoapods.org/pods/KeychainAccess
    
    func saveToken(_ token: String) {
        let key = Keychain(service: serviceName)
        self.token = token
        key["token"] = token
    }
    
    func getToken() -> String? {
        if self.token == nil {
            var token: String?
            let key = Keychain(service: serviceName)
            token = key["token"]
            self.token = token
        }
        
        return self.token!
    }
    
    func deleteToken() {
        self.token = nil
        let key = Keychain(service: serviceName)
        key["token"] = nil
    }
}
