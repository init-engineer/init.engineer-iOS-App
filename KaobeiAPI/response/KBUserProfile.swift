//
//  KBUserProfile.swift
//  KaobeiAPI
//
//  Created by horo on 1/20/21.
//  Copyright © 2021 Kantai Developer. All rights reserved.
//

import Foundation

public struct KBUserProfile: Codable {
    public let data: Profile
}

public struct Profile: Codable {
    public let id: Int
    public let uuid: String
    public let fullName, lastName, firstName: String?
    public let email: String
    public let avatar: String
    public let active, confirmed: Bool
    public let timezone: String

    public enum CodingKeys: String, CodingKey {
        case id, uuid
        case fullName = "full_name"
        case lastName = "last_name"
        case firstName = "first_name"
        case email, avatar, active, confirmed, timezone
    }
}
