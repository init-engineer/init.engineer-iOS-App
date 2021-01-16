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
    //取得文章列表
    static let articleList = "https://kaobei.engineer/api/frontend/social/cards?page="
    //取得文章詳細資訊
    static let articleDetail = "https://kaobei.engineer/api/frontend/social/cards/"
    static let articleDetailSuffix = "/show"
    //取得文章社群連結、讚數、分享數
    static let articleStats = "/links"
    //取得文章回覆
    static let articleComments = "/comments"
    //（AUTH：API）取得使用者個人資訊
    
    //（AUTH：API）取得自己文章列表
    
    //（AUTH：API）發表文章
    
    //（AUTH：API）取得自己文章列表
    
    //OAuth 取得授權碼
    
    //OAuth 取得 access_token
    
    //（AUTH : API）取得需要審核的文章列表
    
    //（AUTH : API）將文章審核通過
    
    //（AUTH : API）將文章審核不通過
    
}
