//
//  ArticleCell.swift
//  init.engineer-iOS-App
//
//  Created by horo on 1/28/21.
//  Copyright © 2021 Kantai Developer. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds
import KaobeiAPI

class ArticleCell: UITableViewCell {
    var contentString: String?
    var stringTag: String?
    var publishTime: String?
    var enterArticleBtn: UIButton?
    var vote: Int?
    var aye: Int?
    var nay: Int?
    var id: Int?
    
    func makeAds(ads: GADBannerView) {
        contentView.layer.cornerRadius = 10
        ads.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(ads)
        contentView.addConstraints([
            ads.topAnchor.constraint(equalTo: contentView.topAnchor),
            ads.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            ads.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ads.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    func makeArticel(content: Article) {
        contentView.layer.cornerRadius = 10
        self.id = content.id
        self.stringTag = tagConvert(from: content.id)
        self.publishTime = content.createdDiff
        self.contentString = content.content
        
        commonUI()
        self.enterArticleBtn?.addTarget(self, action: #selector(showArticle), for: .touchUpInside)
    }
    
    func makeArticleInReview(content: ArticleUnderReview) {
        contentView.layer.cornerRadius = 10
        self.id = content.id
        self.stringTag = tagConvert(from: content.id)
        self.publishTime = content.createdDiff
        self.contentString = content.content
        self.aye = content.succeeded
        self.nay = content.failed
        self.vote = content.succeeded - content.failed
        
        commonUI()
        self.enterArticleBtn?.addTarget(self, action: #selector(showArticleReview), for: .touchUpInside)
    }
    
    private func commonUI() {
        let upperView = UIView()
        let bottomView = UIView()
        
        upperView.backgroundColor = ColorConstants.Default.backgroundColor
        bottomView.backgroundColor = .white
        
        upperView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(upperView)
        contentView.addSubview(bottomView)
        var bottomHeight: CGFloat = 43.0
        if let _ = self.vote {
            bottomHeight = 71.0
        }
        contentView.addConstraints([
            upperView.topAnchor.constraint(equalTo: contentView.topAnchor),
            upperView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
            upperView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            upperView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottomView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            upperView.heightAnchor.constraint(equalToConstant: 200.0),
            bottomView.heightAnchor.constraint(equalToConstant: bottomHeight)
        ])
        
        let articleView = UILabel()
        articleView.textColor = ColorConstants.Default.textColor
        articleView.text = self.contentString
        articleView.numberOfLines = 7
        articleView.lineBreakMode = .byWordWrapping
        articleView.translatesAutoresizingMaskIntoConstraints = false
        
        upperView.addSubview(articleView)
        upperView.addConstraints([
            articleView.topAnchor.constraint(equalTo: upperView.topAnchor, constant: 8.0),
            articleView.bottomAnchor.constraint(equalTo: upperView.bottomAnchor, constant: -8.0),
            articleView.leadingAnchor.constraint(equalTo: upperView.leadingAnchor, constant: 8.0),
            articleView.trailingAnchor.constraint(equalTo: upperView.trailingAnchor, constant: -8.0)
        ])
        
        let tagLabel = UILabel()
        let timeLabel = UILabel()
        self.enterArticleBtn = UIButton()
        tagLabel.text = self.stringTag
        //tagLabel.font = FontConstant.Default.textFont
        timeLabel.text = self.publishTime
        //timeLabel.font = FontConstant.Default.textFont
        
        
        guard let enterArticleBtn = self.enterArticleBtn else {
            return
        }
        
        enterArticleBtn.setTitle("詳細內容", for: .normal)
        enterArticleBtn.setTitleColor(ColorConstants.Default.buttonTextColor, for: .normal)
        //enterArticleBtn.titleLabel?.font = FontConstant.Default.textFont
        
        
        tagLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        enterArticleBtn.translatesAutoresizingMaskIntoConstraints = false
        
        if let _ = self.vote {
            let ayeLabel = UILabel()
            let voteLabel = UILabel()
            let nayLabel = UILabel()
            ayeLabel.text = "\(self.aye ?? 0)"
            voteLabel.text = "\(self.vote ?? 0)"
            nayLabel.text = "\(self.nay ?? 0)"
            //ayeLabel.font = FontConstant.Default.textFont
            //voteLabel.font = FontConstant.Default.textFont
            //nayLabel.font = FontConstant.Default.textFont
            ayeLabel.translatesAutoresizingMaskIntoConstraints = false
            voteLabel.translatesAutoresizingMaskIntoConstraints = false
            nayLabel.translatesAutoresizingMaskIntoConstraints = false
            
            bottomView.addSubview(tagLabel)
            bottomView.addSubview(timeLabel)
            bottomView.addSubview(enterArticleBtn)
            bottomView.addSubview(ayeLabel)
            bottomView.addSubview(voteLabel)
            bottomView.addSubview(nayLabel)
            
            bottomView.addConstraints([
                voteLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 15.0),
                ayeLabel.centerYAnchor.constraint(equalTo: voteLabel.centerYAnchor),
                nayLabel.centerYAnchor.constraint(equalTo: voteLabel.centerYAnchor),
                voteLabel.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor),
                ayeLabel.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor, constant: -bottomView.center.x / 2),
                nayLabel.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor, constant: bottomView.center.x / 2),
                tagLabel.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor),
                tagLabel.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -10.0),
                tagLabel.topAnchor.constraint(equalTo: voteLabel.topAnchor, constant: 10.0),
                timeLabel.centerYAnchor.constraint(equalTo: tagLabel.centerYAnchor),
                enterArticleBtn.centerYAnchor.constraint(equalTo: tagLabel.centerYAnchor),
                tagLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 19.0),
                enterArticleBtn.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -19.0),
                timeLabel.leadingAnchor.constraint(greaterThanOrEqualTo: tagLabel.trailingAnchor),
                enterArticleBtn.leadingAnchor.constraint(greaterThanOrEqualTo: timeLabel.trailingAnchor)
            ])
            
            
        } else {
            bottomView.addSubview(tagLabel)
            bottomView.addSubview(timeLabel)
            bottomView.addSubview(enterArticleBtn)
            
            bottomView.addConstraints([
                tagLabel.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor),
                tagLabel.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -10.0),
                tagLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 15.0),
                timeLabel.centerYAnchor.constraint(equalTo: tagLabel.centerYAnchor),
                enterArticleBtn.centerYAnchor.constraint(equalTo: tagLabel.centerYAnchor),
                tagLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 19.0),
                enterArticleBtn.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -19.0),
                timeLabel.leadingAnchor.constraint(greaterThanOrEqualTo: tagLabel.trailingAnchor),
                enterArticleBtn.leadingAnchor.constraint(greaterThanOrEqualTo: timeLabel.trailingAnchor)
            ])
        }
    }
    
    @objc func showArticle() {
        // push/present self.id
    }
    
    @objc func showArticleReview() {
        
    }
    
    private func tagConvert(from id: Int) -> String {
        var tag = ""
        var carry = id
        
        while carry > 0 {
            tag = digitMapping(from: carry % 36) + tag
            carry = carry / 36
        }
        
        tag = "#純靠北工程師" + tag
        return tag
    }
    
    private func digitMapping(from num: Int) -> String { //
        let convertMap = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
        return convertMap[num]
    }
}
