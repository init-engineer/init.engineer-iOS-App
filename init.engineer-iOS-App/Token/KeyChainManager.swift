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
    
    func saveToken(_ token: String) {
        let key = Keychain(service: "kaobei")
        self.token = token
        key["token"] = token
    }
    
    func getToken() -> String {
        if self.token == nil {
            var token = ""
            let key = Keychain(service: "kaobei")
            token = key["token"] ?? ""
            self.token = token
        }
        
        return self.token!
    }
    
}
