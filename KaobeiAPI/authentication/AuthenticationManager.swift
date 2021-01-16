//
//  AuthenticationManager.swift
//  KaobeiAPI
//
//  Created by horo on 1/17/21.
//  Copyright © 2021 Kantai Developer. All rights reserved.
//

// Oauth2 flow is refered from https://docs.tizen.org/application/native/guides/personal/media/oauth2_protocol_flow.png


import Foundation

enum AuthorizationServer {
    case bitbucket
    case github
    case apple
}

public class AuthenticationManager {
    
    static func loginWithGithub(complite token: @escaping (String) -> ()) {
        
    }
    
    static func loginWithBitbucket(complite token: @escaping (String) -> ()) {
        
    }
    
    static func loginWithOauth2(server: AuthorizationServer, complite accessToken: @escaping (String) -> ()) { // Use this one if the flow is same, and remove others
        GrantRequest.get() {(grant) in
            TokenRequest.get(with: grant) {(token) in
                accessToken(token)
            }
        }
    }
    
    static func loginWithKaobeiAccount() {
        
    }
    
    static func loginWithApple() {
        
    }
}
