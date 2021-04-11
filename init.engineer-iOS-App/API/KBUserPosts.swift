//
//  KBUserPosts.swift
//  KaobeiAPI
//
//  Created by horo on 1/20/21.
//

import Foundation

public struct KBUserPosts: Codable {
    public let data: [Post]
    public let meta: Meta
}

public struct Post: Codable {
    public let id: Int
    public let content: String
    public let image: String
    public let isBanned: Int
    public let bannedRemarks: String? // What is this?
    public let createdAt, createdDiff, updatedAt, updatedDiff: String

    public enum CodingKeys: String, CodingKey {
        case id, content, image
        case isBanned = "is_banned"
        case bannedRemarks = "banned_remarks"
        case createdAt = "created_at"
        case createdDiff = "created_diff"
        case updatedAt = "updated_at"
        case updatedDiff = "updated_diff"
    }
}

