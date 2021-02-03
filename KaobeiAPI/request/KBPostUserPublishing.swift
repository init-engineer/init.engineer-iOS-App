//
//  KBPostUserPublishing.swift
//  KaobeiAPI
//
//  Created by horo on 1/20/21.
//  Copyright © 2021 Kantai Developer. All rights reserved.
//

import Foundation
import Alamofire

public struct KBPostUserPublishing: KaobeiRequestProtocol {
    public enum Theme: String, CodingKey {
        case 黑底綠字 = "2e6046c7387d8fbe9acd700394a3add3"
    }
    
    public enum Fonts: String, CodingKey {
        case Auraka = "ea98dde8987df3cd8aef75479019b688"
    }
    
    public enum ContentType: String {
        case image = "multipart/form-data"
        case article = "application/x-www-form-urlencoded"
    }
    
    public var apiPath: String
    
    public var method: HTTPMethod = .post
    
    public var token: String
    
    public var contentTpye = ContentType.article
    
    public var httpBody = [String: Any]()
    
    public typealias responseType = KBUserPublishing
    
    public var headers: HTTPHeaders? {
        var header = HTTPHeaders()
        let authorization = "Bearer \(token)"
        
        header.add(name: "Accept", value: "application/json")
        header.add(name: "Content-Type", value: contentTpye.rawValue)
        header.add(name: "Authorization", value: authorization)
        
        return header
    }
    
    public var parameters: [String : Any]? {
        return httpBody
    }
    
    public init(accessToken: String, article: String, font: String, theme: String, image: Data? = nil) {
        apiPath = String(format: KaobeiURL.userPublishing)
        self.token = accessToken
        
        httpBody["content"] = article
        httpBody["themeStyle"] = theme // TODO: Needs to convert to string
        httpBody["fontStyle"] = font // TODO: Needs to convert to string
        
        if let image = image {
            contentTpye = .image
            // add image file to body
            httpBody["avatar"] = image
        }
    }
}
