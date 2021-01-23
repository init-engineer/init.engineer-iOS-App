//
//  KBUserProfile.swift
//  KaobeiAPI
//
//  Created by horo on 1/20/21.
//  Copyright © 2021 Kantai Developer. All rights reserved.
//

import Foundation

struct KBUserProfile: Codable {
    let data: Profile
}

struct Profile: Codable {
    let id: Int
    let uuid: String
    let fullName, lastName, firstName: String?
    let email: String
    let avatar: String
    let active, confirmed: Bool
    let timezone: String

    enum CodingKeys: String, CodingKey {
        case id, uuid
        case fullName = "full_name"
        case lastName = "last_name"
        case firstName = "first_name"
        case email, avatar, active, confirmed, timezone
    }
}
