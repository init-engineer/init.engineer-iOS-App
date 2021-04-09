//
//  ReviewCellData.swift
//  init.engineer-iOS-App
//
//  Created by Chen, Yuting | Eric | RP on 2021/02/23.
//  Copyright © 2021 Kantai Developer. All rights reserved.
//

import Foundation


class ReviewCellData {
    let content: String
    let id: Int
    private(set) var aye: Int
    private(set) var nay: Int
    private(set) var vote: Int
    private(set) var review: Int
    let publishTime: String
    let image: String
    
    init(cellData: ArticleUnderReview) {
        self.content = cellData.content
        self.id = cellData.id
        self.aye = cellData.succeeded
        self.nay = cellData.failed
        self.review = cellData.review
        self.vote = self.aye + self.nay
        self.publishTime = cellData.createdDiff
        self.image = cellData.image
    }
    
    func updateVote(aye: Int, nay: Int) {
        self.aye = aye
        self.nay = nay
        self.vote = self.aye + self.nay
        self.review = 1
    }
}
