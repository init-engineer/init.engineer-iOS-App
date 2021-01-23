//
//  KBGetArticleComments.swift
//  KaobeiAPI
//
//  Created by horo on 1/16/21.
//  Copyright © 2021 Kantai Developer. All rights reserved.
//

import Foundation
import Alamofire

struct KBGetArticleComments: KaobeiRequestProtocol {
    var apiPath: String
    
    var method: HTTPMethod = .get
    
    public typealias responseType = KBArticleComments
    
    init(id: Int, page: Int = 1) {
        apiPath = String(format: KaobeiURL.articleComments, id, page)
    }
}

