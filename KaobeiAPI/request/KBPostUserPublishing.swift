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
    enum Theme {
        
    }
    
    enum Fonts {
        
    }
    
    enum ContentType: String {
        case image = "multipart/form-data"
        case article = "application/x-www-form-urlencoded"
    }
    
    var apiPath: String
    
    var method: HTTPMethod = .post
    
    var token: String
    
    var contentTpye = ContentType.article
    
    public typealias responseType = KBUserPublishing
    
    var headers: HTTPHeaders? {
        var header = HTTPHeaders()
        let authorization = "Bearer \(token)"
        
        header.add(name: "Accept", value: "application/json")
        header.add(name: "Content-Type", value: contentTpye.rawValue)
        header.add(name: "Authorization", value: authorization)
        
        return header
    }
    
    init(accessToken: String, article: String, font: Fonts, theme: Theme) {
        apiPath = String(format: KaobeiURL.userPublishing)
        self.token = accessToken
    }
    
    init(accessToken: String, image: String) { // image link?
        apiPath = String(format: KaobeiURL.userPublishing)
        self.token = accessToken
        contentTpye = .image
    }
}
