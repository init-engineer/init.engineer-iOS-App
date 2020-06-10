//
//  APIGate.swift
//  init.engineer-iOS-App
//
//  Created by horo on 6/9/20.
//  Copyright © 2020 Kantai Developer. All rights reserved.
//

import Foundation

class APIGate {
    let BaseURL =  "https://kaobei.engineer/"
    var user = 0 //TODO: create a user-class
    
    init() {
        
    }
    
    // MARK: Public access
    // GET 取得文章列表
    func getArticleList(from page: Int) {
        let BodyURL = "api/frontend/social/cards"
        
    }
    
    // GET 取得文章詳細資訊
    func getArticleDetails(from id: Int) {
        let BodyURL = "api/frontend/social/cards/\(id)/show"
        
    }
    
    // GET 取得文章社群連結、讚數、分享數
    func getArticleLinks(from id: Int) {
        let BodyURL = "api/frontend/social/cards/\(id)/links"
        
    }
    
    // GET 取得文章回覆
    func getArticleComments(from id: Int, and page: Int) {
        let BodyURL = "api/frontend/social/cards/\(id)/comments"
        
    }
    
    // MARK: Auth: API
    // GET （AUTH：API）取得使用者個人資訊\
    func getUserProfileWithAPI() {
        let BodyURL = "api/frontend/user/profile"
        
    }
    
    // GET （AUTH : API）取得自己文章列表
    func getUserArticleListWithAPI() {
        let BodyURL = "api/frontend/social/cards/api/dashboard"
        
    }
    
    // POST （AUTH : API）發表文章
    func postArticleWithAPI() {
        let BodyURL = "api/frontend/social/cards/api/publish"
        
    }
    
    // GET （AUTH : API）取得需要審核的文章列表
    func getUnjudgedListWithAPI() {
        let BodyURL = "api/frontend/social/cards/api/review"
    }
    // GET （AUTH : API）將文章審核通過
    func getArticleAcceptWithAPI(with ArticleID: Int) {
        let BodyURL = "api/frontend/social/cards/api/review/\(ArticleID)/succeeded"
    }
    // GET （AUTH : API）將文章審核不通過
    func getArticleDenyWithAPI(with ArticleID: Int) {
        let BodyURL = "api/frontend/social/cards/api/review/\(ArticleID)/failed"
    }
    
    // MARK: Auth: Token
    // GET （AUTH : TOKEN）取得自己文章列表
    func getUserArticleListWithToken() {
        let BodyURL = "api/frontend/social/cards/token/dashboard"
    }
    // POST （AUTH : TOKEN）發表文章
    func postArticleWithToken() {
        let BodyURL = "api/frontend/social/cards/token/publish"
    }
    // GET （AUTH : TOKEN）取得需要審核的文章列表
    func getUnjudgedListWithToken() {
        let BodyURL = "api/frontend/social/cards/token/review"
    }
    // GET （AUTH : TOKEN）將文章審核通過
    func getArticleAcceptWithToken(with ArticleID: Int) {
        let BodyURL = "api/frontend/social/cards/token/review/\(ArticleID)" // Maybe wrong URL
    }
    // GET （AUTH : TOKEN）將文章審核不通過
    func getArticleDenyWithToken(with ArticleID: Int) {
        let BodyURL = "api/frontend/social/cards/token/review/\(ArticleID)/failed"
    }
    // MARK: OAuth
    // GET OAuth 取得授權碼
    func getOAuthCode(from redirect_uri: URL, for client_id: Int) {
        let BodyURL = "oauth/authorize?client_id=\(client_id)&redirect_uri=\(redirect_uri)&response_type=code&scope=*"
    }
    
    // POST OAuth 取得 access_token
    func postOAuthToken(from redirect_uri: URL, for client_id: Int, and client_secret: Int, with code: Int) {
        let BodyURL = "oauth/token"
    }
}
