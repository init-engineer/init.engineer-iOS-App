//
//  KBGetArticleList.swift
//  KaobeiAPI
//
//  Created by horo on 10/20/20.
//  Copyright © 2020 Kantai Developer. All rights reserved.
//

import Foundation
import Alamofire

class KBGetArticleList: KaobeiRequestProtocol {
    var apiPath: String
    
    var method: HTTPMethod = .get
    
    typealias responseType = KBArticleList
    
    init(page: Int) {
        apiPath = "api/frontend/social/cards?page=\(page)"
    }
}
