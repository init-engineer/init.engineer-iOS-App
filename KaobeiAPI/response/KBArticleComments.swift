//
//  KBArticleComments.swift
//  KaobeiAPI
//
//  Created by horo on 1/16/21.
//  Copyright © 2021 Kantai Developer. All rights reserved.
//

import Foundation

// MARK: - Welcome
public struct KBArticleComments {
    let data: [Comment]
    let meta: Meta
}

// MARK: - Datum
struct Comment {
    let name, avatar, content, created: String
    let media: Media
}

// MARK: - Media
struct Media {
    let type, connections: String
}
