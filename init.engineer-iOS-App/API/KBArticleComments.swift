//
//  KBArticleComments.swift
//  KaobeiAPI
//
//  Created by horo on 1/16/21.
//

import Foundation

// MARK: - Welcome
public struct KBArticleComments: Codable {
    public let data: [Comment]
    public let meta: Meta
}

// MARK: - Datum
public struct Comment: Codable {
    public let name, avatar, content, created: String
    public let media: Media
}

// MARK: - Media
public struct Media: Codable {
    public let type, connections: String
}
