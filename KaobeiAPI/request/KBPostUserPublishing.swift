//
//  KBPostUserPublishing.swift
//  KaobeiAPI
//
//  Created by horo on 1/20/21.
//  Copyright © 2021 Kantai Developer. All rights reserved.
//

import Foundation
import Alamofire

struct KBPostUserPublishing: KaobeiRequestProtocol {
    enum Theme: String, CodingKey {
        case 黑底綠字 = "2e6046c7387d8fbe9acd700394a3add3"
    }
    
    enum Fonts: String, CodingKey {
        case Auraka = "ea98dde8987df3cd8aef75479019b688"
    }
    
    enum ContentType: String {
        case image = "multipart/form-data"
        case article = "application/x-www-form-urlencoded"
    }
    
    var apiPath: String
    
    var method: HTTPMethod = .post
    
    var token: String
    
    var contentTpye = ContentType.article
    
    var httpBody = [String: Any]()
    
    public typealias responseType = KBUserPublishing
    
    var headers: HTTPHeaders? {
        var header = HTTPHeaders()
        let authorization = "Bearer \(token)"
        
        header.add(name: "Accept", value: "application/json")
        header.add(name: "Content-Type", value: contentTpye.rawValue)
        header.add(name: "Authorization", value: authorization)
        
        return header
    }
    
    var parameters: [String : Any]? {
        return httpBody
    }
    
    init(accessToken: String, article: String, font: Fonts, theme: Theme, image: Data? = nil) {
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
