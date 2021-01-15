//
//  KBArticleList.swift
//  KaobeiAPI
//
//  Created by horo on 10/20/20.
//  Copyright © 2020 Kantai Developer. All rights reserved.
//

import Foundation

public struct KBArticleList: Codable {
    let data: [Article]
    let meta: Meta
}

// MARK: - Datum
public struct Article: Codable {
    let id: Int
    let content: String
    let image: String
    let createdAt, createdDiff, updatedAt, updatedDiff: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case content
        case image
        case createdAt = "created_at"
        case createdDiff = "created_diff"
        case updatedAt = "updated_at"
        case updatedDiff = "updated_diff"
    }
}

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
