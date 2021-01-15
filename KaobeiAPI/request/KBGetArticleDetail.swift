//
//  KBGetArticleDetail.swift
//  KaobeiAPI
//
//  Created by horo on 1/16/21.
//  Copyright © 2021 Kantai Developer. All rights reserved.
//

import Foundation
import Alamofire

struct KBGetArticleDetail: KaobeiRequestProtocol {
    var apiPath: String
    
    var method: HTTPMethod = .get
    
    public typealias responseType = KBArticleDetail
    
    init(id: Int) {
        apiPath = String(format: "%@%d%@", KaobeiURL.articleDetail, id, KaobeiURL.articleDetailSuffix)
    }
}
