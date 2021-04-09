//
//  KBGetArticleList.swift
//  KaobeiAPI
//
//  Created by horo on 10/20/20.
//  Copyright © 2020 Kantai Developer. All rights reserved.
//

import Foundation
import Alamofire

public struct KBGetArticleList: KaobeiRequestProtocol {
    public var apiPath: String
    
    public var method: HTTPMethod = .get
    
    public typealias responseType = KBArticleList
    
    public init(page: Int) {
        apiPath = String(format: KaobeiURL.articleList, page)
    }
}
