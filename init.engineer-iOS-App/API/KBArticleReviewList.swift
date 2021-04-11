//
//  KBArticleReviewList.swift
//  KaobeiAPI
//
//  Created by horo on 1/20/21.
//

import Foundation

public struct KBArticleReviewList: Codable {
    public let data: [ArticleUnderReview]
    public let meta: Meta
}

public struct ArticleUnderReview: Codable {
    public let id: Int
    public let content: String
    public let image: String
    public let succeeded, failed: Int
    public let createdAt, createdDiff, updatedAt, updatedDiff: String
    public let review: Int

    public enum CodingKeys: String, CodingKey {
        case id, content, image, succeeded, failed
        case createdAt = "created_at"
        case createdDiff = "created_diff"
        case updatedAt = "updated_at"
        case updatedDiff = "updated_diff"
        case review
    }
}
