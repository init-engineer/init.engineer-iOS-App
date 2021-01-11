//
//  KBArticleList.swift
//  KaobeiAPI
//
//  Created by horo on 10/20/20.
//  Copyright © 2020 Kantai Developer. All rights reserved.
//

import Foundation

struct KBArticleList: Codable {
    let data: [Article]
    let meta: Meta
}

// MARK: - Datum
struct Article: Codable {
    let id: Int
    let content: String
    let image: String
    let createdAt, createdDiff, updatedAt, updatedDiff: String
}

// MARK: - Meta
struct Meta: Codable {
    let pagination: Pagination
}

// MARK: - Pagination
struct Pagination: Codable {
    let total, count, perPage, currentPage: Int
    let totalPages: Int
    let links: Links
}

// MARK: - Links
struct Links: Codable {
    let next: String
}
