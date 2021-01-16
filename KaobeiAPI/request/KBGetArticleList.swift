//
//  KBGetArticleList.swift
//  KaobeiAPI
//
//  Created by horo on 10/20/20.
//  Copyright © 2020 Kantai Developer. All rights reserved.
//

import Foundation
import Alamofire

struct KBGetArticleList: KaobeiRequestProtocol {
    var apiPath: String
    
    var method: HTTPMethod = .get
    
    public typealias responseType = KBArticleList
    
    init(page: Int) {
        apiPath = String(format: KaobeiURL.articleList, page)
    }
}
