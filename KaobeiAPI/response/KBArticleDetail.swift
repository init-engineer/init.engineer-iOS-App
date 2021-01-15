//
//  KBArticleDetail.swift
//  KaobeiAPI
//
//  Created by horo on 1/16/21.
//  Copyright © 2021 Kantai Developer. All rights reserved.
//

import Foundation

public struct KBArticleDetail: Codable {
    let data: Article
}

// MARK: - Article
struct Article: Codable {
    let id: Int
    let content: String
    let image: String
    let createdAt, createdDiff, updatedAt, updatedDiff: String

    enum CodingKeys: String, CodingKey {
        case id, content, image
        case createdAt = "created_at"
        case createdDiff = "created_diff"
        case updatedAt = "updated_at"
        case updatedDiff = "updated_diff"
    }
}
