//
//  KBArticleStats.swift
//  KaobeiAPI
//
//  Created by horo on 1/16/21.
//  Copyright © 2021 Kantai Developer. All rights reserved.
//

import Foundation

public struct KBGetArticleStats {
    let data: [StatsSource]
}

// MARK: - Datum
struct StatsSource {
    let type, connections: String
    let url: String
    let like, share: Int
}
