//
//  KBCommonTypes.swift
//  KaobeiAPI
//
//  Created by horo on 1/20/21.
//  Copyright © 2021 Kantai Developer. All rights reserved.
//

import Foundation

// MARK: - Meta
public struct Meta: Codable {
    public let pagination: Pagination
}

// MARK: - Pagination
public struct Pagination: Codable {
    public let total, count, perPage, currentPage: Int
    public let totalPages: Int
    public let links: Links?
    
    public enum CodingKeys: String, CodingKey {
        case total
        case count
        case perPage = "per_page"
        case currentPage = "current_page"
        case totalPages = "total_pages"
        case links
    }
}

// MARK: - Links
public struct Links: Codable {
    public let next: String?
}

public struct VotedArticle: Codable {
    public let id: Int
    public let content: String
    public let image: String
    public let succeeded, failed: Int
    public let createdAt, createdDiff, updatedAt, updatedDiff: String

    public enum CodingKeys: String, CodingKey {
        case id, content, image, succeeded, failed
        case createdAt = "created_at"
        case createdDiff = "created_diff"
        case updatedAt = "updated_at"
        case updatedDiff = "updated_diff"
    }
}

// MARK: - Article
public struct Article: Codable {
    public let id: Int
    public let content: String
    public let image: String
    public let createdAt, createdDiff, updatedAt, updatedDiff: String

    public enum CodingKeys: String, CodingKey {
        case id, content, image
        case createdAt = "created_at"
        case createdDiff = "created_diff"
        case updatedAt = "updated_at"
        case updatedDiff = "updated_diff"
    }
}
