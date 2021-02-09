//
//  KaobeiURL.swift
//  KaobeiAPI
//
//  Created by horo on 1/11/21.
//  Copyright © 2021 Kantai Developer. All rights reserved.
//

import Foundation

struct KaobeiURL {
    static let basePath = "https://kaobei.engineer/"
    //取得文章列表 (Int)
    static let articleList = "https://kaobei.engineer/api/frontend/social/cards?page=%d"
    //取得文章詳細資訊 (Int)
    static let articleDetail = "https://kaobei.engineer/api/frontend/social/cards/%d/show"
    //取得文章社群連結、讚數、分享數(Int)
    static let articleStats = "https://kaobei.engineer/api/frontend/social/cards/%d/links"
    //取得文章回覆(Int, Int)
    static let articleComments = "https://kaobei.engineer/api/frontend/social/cards/%d/comments?page=%d"
    //（AUTH：API）取得使用者個人資訊
    static let userProfile = "https://kaobei.engineer/api/frontend/user/profile"
    //（AUTH：API）取得自己文章列表(Int)
    static let userPosts = "https://kaobei.engineer/api/frontend/social/cards/api/dashboard?page=%d"
    //（AUTH：API）發表文章
    static let userPublishing = "https://kaobei.engineer/api/frontend/social/cards/api/publish"
    //OAuth 取得授權碼(Int, String, String, String)
    static let requestGrant = "https://kaobei.engineer/oauth/authorize?client_id=%d&redirect_uri=%@&response_type=%@&scope=%@"
    //OAuth 取得 access_token
    static let requestToken = "https://kaobei.engineer/oauth/token"
    //（AUTH : API）取得需要審核的文章列表
    static let articleReviewList = "https://kaobei.engineer/api/frontend/social/cards/api/review?page=%d"
    //（AUTH : API）將文章審核通過(Int)
    static let articleVoteAye = "https://kaobei.engineer/api/frontend/social/cards/api/review/%d/succeeded"
    //（AUTH : API）將文章審核不通過(Int)
    static let articleVoteNay = "https://kaobei.engineer/api/frontend/social/cards/api/review/%id/failed"
}
