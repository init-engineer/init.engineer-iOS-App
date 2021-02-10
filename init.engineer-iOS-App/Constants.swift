//
//  Constants.swift
//  init.engineer-iOS-App
//
//  Created by 楊承昊 on 2021/1/21.
//  Copyright © 2021 Kantai Developer. All rights reserved.
//

import Foundation
import UIKit

struct K {
    static func getInfoPlistByKey(_ key: String) -> String? {
        return (Bundle.main.infoDictionary?[key] as? String)?
            .replacingOccurrences(of: "\\", with: "")
    }
    static let dashboardToLoginSegue = "DashboardToLogin"
    static let publishToLoginSegue = "PublishToLogin"
    static let reviewToLoginSegue = "ReviewToLogin"
    static let publishArticlePlaceholderText = "跟大家分享你的靠北事吧。"
    static let publishArticlePlaceholderTextColor = UIColor(white: 0xD3/255.0, alpha: 0.7)
    static let ToArticleDetailsSegue = "ToArticleDetails"
    static let ToReviewDetailsSegue = "ToReviewDetails"
    static let articleTableViewCell = "ArticleTableViewCell"
    static let articleTableViewCellIdentifier = "ArticleTableViewCellIdentifier"
    static func tagConvert(from id: Int) -> String {
        var tag = ""
        var carry = id
        while carry > 0 {
            tag = digitMapping(from: carry % 36) + tag
            carry = carry / 36
        }
        tag = "#純靠北工程師" + tag
        return tag
    }
    static private func digitMapping(from num: Int) -> String { //
        let convertMap = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
        return convertMap[num]
    }
}
