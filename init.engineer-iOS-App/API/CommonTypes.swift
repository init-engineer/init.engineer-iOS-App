//
//  KBCommonTypes.swift
//  KaobeiAPI
//
//  Created by horo on 1/20/21.
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

}

// MARK: - Article
public struct Article: Codable {
    public let id: Int
    public let content: String
    public let image: String
    public let createdAt, createdDiff, updatedAt, updatedDiff: String

}
