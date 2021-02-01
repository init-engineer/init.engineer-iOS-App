//
//  Constants.swift
//  init.engineer-iOS-App
//
//  Created by 楊承昊 on 2021/1/21.
//  Copyright © 2021 Kantai Developer. All rights reserved.
//

import Foundation

struct K {
    static func getInfoPlistByKey(_ key: String) -> String? {
        return (Bundle.main.infoDictionary?[key] as? String)?
            .replacingOccurrences(of: "\\", with: "")
    }
    static let dashboardToLoginSegue = "DashboardToLogin"
    static let publishToLoginSegue = "PublishToLogin"
    static let reviewToLoginSegue = "ReviewToLogin"
    static let ToArticleDetailsSegue = "ToArticleDetails"
    static let ToReviewDetailsSegue = "ToReviewDetails"
}
