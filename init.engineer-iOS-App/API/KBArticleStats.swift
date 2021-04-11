//
//  KBArticleStats.swift
//  KaobeiAPI
//
//  Created by horo on 1/16/21.
//

import Foundation

public struct KBArticleStats: Codable {
    public let data: [StatsSource]
}

// MARK: - Datum
public struct StatsSource: Codable {
    public let type, connections: String
    public let url: String
    public let like, share: Int
}
