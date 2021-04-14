//
//  KBUserPosts.swift
//  KaobeiAPI
//
//  Created by horo on 1/20/21.
//

import Foundation

public struct Post: Codable {
    public let id: Int
    public let content: String
    public let image: String
    public let isBanned: Int
    public let bannedRemarks: String?
    public let createdAt, createdDiff, updatedAt, updatedDiff: String

}

