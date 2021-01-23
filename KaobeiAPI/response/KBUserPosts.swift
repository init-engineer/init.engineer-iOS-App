//
//  KBUserPosts.swift
//  KaobeiAPI
//
//  Created by horo on 1/20/21.
//  Copyright © 2021 Kantai Developer. All rights reserved.
//

import Foundation

struct KBUserPosts: Codable {
    let data: [Post]
    let meta: Meta
}

struct Post: Codable {
    let id: Int
    let content: String
    let image: String
    let isBanned: Int
    let bannedRemarks: String? // What is this?
    let createdAt, createdDiff, updatedAt, updatedDiff: String

    enum CodingKeys: String, CodingKey {
        case id, content, image
        case isBanned = "is_banned"
        case bannedRemarks = "banned_remarks"
        case createdAt = "created_at"
        case createdDiff = "created_diff"
        case updatedAt = "updated_at"
        case updatedDiff = "updated_diff"
    }
}

