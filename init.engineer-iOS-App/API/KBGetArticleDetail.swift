//
//  KBGetArticleDetail.swift
//  KaobeiAPI
//
//  Created by horo on 1/16/21.
//

import Foundation
import Alamofire

public struct KBGetArticleDetail: KaobeiRequestProtocol {
    public var apiPath: String
    
    public var method: HTTPMethod = .get
    
    public typealias responseType = KBArticleDetail
    
    public init(id: Int) {
        apiPath = String(format: KaobeiURL.articleDetail, id)
    }
}
