//
//  KBGetArticleVoteAye.swift
//  KaobeiAPI
//
//  Created by horo on 1/20/21.
//  Copyright © 2021 Kantai Developer. All rights reserved.
//

import Foundation
import Alamofire

struct KBGetArticleVoteAye: KaobeiRequestProtocol {
    var apiPath: String
    
    var method: HTTPMethod = .get
    
    var token: String
    
    public typealias responseType = KBArticleVoteAye
    
    var headers: HTTPHeaders? {
        var header = HTTPHeaders()
        let authorization = "Bearer \(token)"
        
        header.add(name: "Accept", value: "application/json")
        header.add(name: "Content-Type", value: "application/x-www-form-urlencoded")
        header.add(name: "Authorization", value: authorization)
        
        return header
    }
    
    init(accessToken: String, id: Int) {
        apiPath = String(format: KaobeiURL.articleVoteAye, id)
        self.token = accessToken
    }
}
