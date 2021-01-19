//
//  KBArticleReviewList.swift
//  KaobeiAPI
//
//  Created by horo on 1/20/21.
//  Copyright © 2021 Kantai Developer. All rights reserved.
//

import Foundation

struct KBArticleReviewList: Codable {
    let data: [ArticleUnderReview]
    let meta: Meta
}

struct ArticleUnderReview: Codable {
    let id: Int
    let content: String
    let image: String
    let succeeded, failed: Int
    let createdAt, createdDiff, updatedAt, updatedDiff: String
    let review: Int

    enum CodingKeys: String, CodingKey {
        case id, content, image, succeeded, failed
        case createdAt = "created_at"
        case createdDiff = "created_diff"
        case updatedAt = "updated_at"
        case updatedDiff = "updated_diff"
        case review
    }
}
