//
//  KBArticleComments.swift
//  KaobeiAPI
//
//  Created by horo on 1/16/21.
//  Copyright © 2021 Kantai Developer. All rights reserved.
//

import Foundation

// MARK: - Welcome
public struct KBArticleComments: Codable {
    let data: [Comment]
    let meta: Meta
}

// MARK: - Datum
struct Comment: Codable {
    let name, avatar, content, created: String
    let media: Media
}

// MARK: - Media
struct Media: Codable {
    let type, connections: String
}
