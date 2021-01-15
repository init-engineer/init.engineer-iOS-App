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
