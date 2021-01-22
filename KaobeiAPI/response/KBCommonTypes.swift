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
    let pagination: Pagination
}

// MARK: - Pagination
public struct Pagination: Codable {
    let total, count, perPage, currentPage: Int
    let totalPages: Int
    let links: Links?
    
    enum CodingKeys: String, CodingKey {
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
    let next: String?
}

struct VotedArticle: Codable {
    let id: Int
    let content: String
    let image: String
    let succeeded, failed: Int
    let createdAt, createdDiff, updatedAt, updatedDiff: String

    enum CodingKeys: String, CodingKey {
        case id, content, image, succeeded, failed
        case createdAt = "created_at"
        case createdDiff = "created_diff"
        case updatedAt = "updated_at"
        case updatedDiff = "updated_diff"
    }
}
