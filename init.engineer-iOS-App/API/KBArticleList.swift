//
//  KBArticleList.swift
//  KaobeiAPI
//
//  Created by horo on 10/20/20.
//

import Foundation

public struct KBArticleList: Codable {
    public let data: [Article]
    public let meta: Meta
}

