//
//  KBGetArticleStats.swift
//  KaobeiAPI
//
//  Created by horo on 1/16/21.
//  Copyright © 2021 Kantai Developer. All rights reserved.
//

import Foundation
import Alamofire

public struct KBGetArticleStats: KaobeiRequestProtocol {
    public var apiPath: String
    
    public var method: HTTPMethod = .get
    
    public typealias responseType = KBArticleStats
    
    public init(id: Int) {
        apiPath = String(format: KaobeiURL.articleStats, id)
    }
}
