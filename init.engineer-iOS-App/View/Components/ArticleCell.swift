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

protocol ArticleCellDelegate {
    func cellClicked(with id: Int)
}

class ArticleCell: UITableViewCell {
    var contentString: String?
    var stringTag: String?
    var publishTime: String?
    var enterArticleBtn: UIButton?
    var vote: Int?
    var aye: Int?
    var nay: Int?
    var id: Int?
    var delegate: ArticleCellDelegate?
    
    func makeAds(ads: GADBannerView) {
        dispatchViews()
        ads.tag = 1
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 10
        ads.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        contentView.addSubview(ads)
        contentView.addConstraints([
            ads.topAnchor.constraint(equalTo: contentView.topAnchor),
            ads.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            ads.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ads.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    func makeArticel(content: Article) {
        dispatchViews()
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 10
        self.id = content.id
        self.stringTag = tagConvert(from: content.id)
        self.publishTime = content.createdDiff
        self.contentString = content.content
        self.backgroundColor = .clear
        commonUI()
        self.enterArticleBtn?.addTarget(self, action: #selector(showArticle), for: .touchUpInside)
    }
    
    func makeArticleInReview(content: ArticleUnderReview) {
        dispatchViews()
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 10
        self.id = content.id
        self.stringTag = tagConvert(from: content.id)
        self.publishTime = content.createdDiff
        self.contentString = content.content
        self.backgroundColor = .clear
        self.aye = content.succeeded
        self.nay = content.failed
        self.vote = content.succeeded + content.failed
        
        commonUI()
        self.enterArticleBtn?.addTarget(self, action: #selector(showArticle), for: .touchUpInside)
    }
    
    private func commonUI() {
        let upperView = UIView()
        let bottomView = UIView()
        
        upperView.tag = 2
        bottomView.tag = 3
        
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
        articleView.lineBreakMode = .byTruncatingTail
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
        tagLabel.font = FontConstant.Default.text
        timeLabel.text = self.publishTime
        timeLabel.font = FontConstant.Default.text
        
        
        guard let enterArticleBtn = self.enterArticleBtn else {
            return
        }
        
        enterArticleBtn.setTitle("詳細內容", for: .normal)
        enterArticleBtn.setTitleColor(ColorConstants.Default.buttonTextColor, for: .normal)
        enterArticleBtn.titleLabel?.font = FontConstant.Default.text
        
        
        tagLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        enterArticleBtn.translatesAutoresizingMaskIntoConstraints = false
        
        if let _ = self.vote {
            let bottomStackView = UIStackView()
            bottomStackView.axis = .horizontal
            bottomStackView.distribution = .equalSpacing
            bottomStackView.alignment = .center
            
            bottomStackView.translatesAutoresizingMaskIntoConstraints = false
            
            bottomStackView.addArrangedSubview(tagLabel)
            bottomStackView.addArrangedSubview(timeLabel)
            bottomStackView.addArrangedSubview(enterArticleBtn)
            
            let ayeLabel = UILabel()
            let voteLabel = UILabel()
            let nayLabel = UILabel()
            ayeLabel.text = "\(self.aye ?? 0)"
            voteLabel.text = "\(self.vote ?? 0)"
            nayLabel.text = "\(self.nay ?? 0)"
            ayeLabel.font = FontConstant.Default.text
            voteLabel.font = FontConstant.Default.text
            nayLabel.font = FontConstant.Default.text
            ayeLabel.translatesAutoresizingMaskIntoConstraints = false
            voteLabel.translatesAutoresizingMaskIntoConstraints = false
            nayLabel.translatesAutoresizingMaskIntoConstraints = false
            
            let upperStackView = UIStackView()
            upperStackView.axis = .horizontal
            upperStackView.distribution = .equalSpacing
            upperStackView.alignment = .center
            
            upperStackView.translatesAutoresizingMaskIntoConstraints = false
            
            upperStackView.addArrangedSubview(ayeLabel)
            upperStackView.addArrangedSubview(voteLabel)
            upperStackView.addArrangedSubview(nayLabel)
            
            bottomView.addSubview(upperStackView)
            bottomView.addSubview(bottomStackView)
            
            bottomView.addConstraints([
                upperStackView.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 15.0),
                upperStackView.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 19.0),
                upperStackView.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -19.0),
                bottomStackView.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -10.0),
                bottomStackView.topAnchor.constraint(equalTo: upperStackView.topAnchor, constant: 10.0),
                bottomStackView.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 19.0),
                bottomStackView.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -19.0)
            ])
            
            
        } else {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.distribution = .equalSpacing
            stackView.alignment = .center
            
            stackView.translatesAutoresizingMaskIntoConstraints = false
            
            stackView.addArrangedSubview(tagLabel)
            stackView.addArrangedSubview(timeLabel)
            stackView.addArrangedSubview(enterArticleBtn)
            
            bottomView.addSubview(stackView)
            
            bottomView.addConstraints([
                stackView.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -10.0),
                stackView.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 15.0),
                stackView.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 19.0),
                stackView.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -19.0),
            ])
        }
    }
    
    func dispatchViews() {
        contentView.viewWithTag(1)?.removeFromSuperview()
        contentView.viewWithTag(2)?.removeFromSuperview()
        contentView.viewWithTag(3)?.removeFromSuperview()
    }
    
    
    @objc func showArticle() {
        guard let id = self.id else { return }
        delegate?.cellClicked(with: id)
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
