//
//  ReviewCellData.swift
//  init.engineer-iOS-App
//
//  Created by horo on 2021/02/23.
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
    
    init() {
        self.content = "100"
        self.id = 100
        self.aye = 0
        self.nay = 0
        self.review = 0
        self.vote = self.aye + self.nay
        self.publishTime = "cellData.createdDiff"
        self.image = "cellData.image"
    }
    
    func updateVote(aye: Int, nay: Int) {
        self.aye = aye
        self.nay = nay
        self.vote = self.aye + self.nay
        self.review = 1
    }
}
