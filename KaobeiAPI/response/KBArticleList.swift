//
//  KBArticleList.swift
//  KaobeiAPI
//
//  Created by horo on 10/20/20.
//  Copyright © 2020 Kantai Developer. All rights reserved.
//

import Foundation

public struct KBArticleList: Codable {
    public let data: [Article]
    public let meta: Meta
}

