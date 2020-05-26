//
//  Kaobei.swift
//  init.engineer-iOS-App
//
//  Created by Eden on 2020/5/25.
//  Copyright © 2020 Kantai Developer. All rights reserved.
//

import Foundation
import Combine
import OAuthSwift

public struct Kaobei
{
    static func authorize(completion: @escaping AuthorizeCompletionHandler)
    {
        let callbackUrl: String = Callback.scheme + "://" + Callback.host + "/" + Callback.path
        let state: String = String.random(length: 20)
        let completionHandler: OAuth2Swift.TokenCompletionHandler = {
            
            result in
            
            let newResult: AuthorizeResult = result.map {
                
                let token: Token = $0.credential.oauthToken
                
                return token
            }
            
            completion(newResult)
        }
        
        let oauthSwift = OAuth2Swift(consumerKey: OAuth.clientId, consumerSecret: OAuth.clientSecret, authorizeUrl: OAuth.authorizeUrl, accessTokenUrl: OAuth.tokenUrl, responseType: "code")
        oauthSwift.authorize(withCallbackURL: callbackUrl, scope: "*", state: state, completionHandler: completionHandler)
    }
    
    private init() { }
}

public extension Kaobei
{
    typealias Token = String
    typealias AuthorizeCompletionHandler = (AuthorizeResult) -> Void
    typealias AuthorizeResult = Result<Token, OAuthSwiftError>
    
    struct Callback {
        
        static let scheme: String = "kaobei"
        
        fileprivate static let host: String = "engineer.kaobei"
        
        fileprivate static let path: String = "callback"
    }
    
    fileprivate struct OAuth {
        
        static let clientId: String = "48763"
        
        static let clientSecret: String = "g1er7841g784er78g48er87g478re48g"
        
        static let authorizeUrl: String = "https://kaobei.engineer/oauth/authorize"
        
        static let tokenUrl: String = "https://kaobei.engineer/oauth/token"
    }
}
