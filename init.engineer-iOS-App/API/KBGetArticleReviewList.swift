//
//  KBGetArticleReviewList.swift
//  KaobeiAPI
//
//  Created by horo on 1/20/21.
//

import Foundation
import Alamofire

public struct KBGetArticleReviewList: KaobeiRequestProtocol {
    public var apiPath: String
    
    public var method: HTTPMethod = .get
    
    public var token: String
    
    public typealias responseType = KBArticleReviewList
    
    public var headers: HTTPHeaders? {
        var header = HTTPHeaders()
        let authorization = "Bearer \(token)"
        
        header.add(name: "Accept", value: "application/json")
        header.add(name: "Content-Type", value: "application/x-www-form-urlencoded")
        header.add(name: "Authorization", value: authorization)
        
        return header
    }
    
    public init(accessToken: String, page: Int) {
        apiPath = String(format: KaobeiURL.articleReviewList, page)
        self.token = accessToken
    }
}
