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

