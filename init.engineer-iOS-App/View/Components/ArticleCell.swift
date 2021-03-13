//
//  ArticleCell.swift
//  init.engineer-iOS-App
//
//  Created by horo on 1/28/21.
//  Copyright © 2021 Kantai Developer. All rights reserved.
//

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
    var id: Int?
    var delegate: ArticleCellDelegate?
    
    func makeAds(ads: GADBannerView) {
        dispatchViews()
        ads.tag = 1
//        contentView.layer.masksToBounds = true
//        contentView.layer.cornerRadius = 10
        ads.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        let placeHolder = UILabel()
        placeHolder.translatesAutoresizingMaskIntoConstraints = false
        placeHolder.text = "G站傲嬌中"
        placeHolder.font = FontConstant.Default.text
        placeHolder.textColor = ColorConstants.Card.textColor
        placeHolder.textAlignment = .center
        
        contentView.addSubview(placeHolder)
        contentView.addSubview(ads)
        contentView.addConstraints([
            placeHolder.topAnchor.constraint(equalTo: contentView.topAnchor),
            placeHolder.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            placeHolder.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            placeHolder.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            ads.topAnchor.constraint(equalTo: contentView.topAnchor),
            ads.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            ads.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ads.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    func makePost(content: Post) {
        dispatchViews()
//        contentView.layer.masksToBounds = true
//        contentView.layer.cornerRadius = 10
        self.id = content.id
        self.stringTag = String.tagConvert(from: content.id)
        self.publishTime = content.createdDiff
        self.contentString = content.content
        self.backgroundColor = .clear
        commonUI()
    }
    
    func makeArticle(content: Article) {
        dispatchViews()
//        contentView.layer.masksToBounds = true
//        contentView.layer.cornerRadius = 10
        self.id = content.id
        self.stringTag = String.tagConvert(from: content.id)
        self.publishTime = content.createdDiff
        self.contentString = content.content
        self.backgroundColor = .clear
        commonUI()
    }
    
    func commonUI() {
        let upperView = UIView()
        let bottomView = UIView()
        
        upperView.tag = 2
        bottomView.tag = 3
        
        upperView.backgroundColor = ColorConstants.Card.backgroundColor
        bottomView.backgroundColor = UIColor(named: "cardBackgroundColor")
        
        upperView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(upperView)
        contentView.addSubview(bottomView)
        contentView.addConstraints([
            upperView.topAnchor.constraint(equalTo: contentView.topAnchor),
            upperView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
            upperView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            upperView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottomView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            upperView.heightAnchor.constraint(equalToConstant: 200.0)
        ])
        
        let articleView = UILabel()
        articleView.textColor = ColorConstants.Card.textColor
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
//        tagLabel.textColor = .black
        timeLabel.text = self.publishTime
        timeLabel.font = FontConstant.Default.text
        
        
        guard let enterArticleBtn = self.enterArticleBtn else {
            return
        }
        
        enterArticleBtn.addTarget(self, action: #selector(showArticle), for: .touchUpInside)
        enterArticleBtn.setTitle("詳細內容", for: .normal)
        enterArticleBtn.setTitleColor(ColorConstants.Card.buttonTextColor, for: .normal)
        enterArticleBtn.titleLabel?.font = FontConstant.Default.text
        
        
        tagLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        enterArticleBtn.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.backgroundColor = .none
        
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
    
    func dispatchViews() {
        contentView.viewWithTag(1)?.removeFromSuperview()
        contentView.viewWithTag(2)?.removeFromSuperview()
        contentView.viewWithTag(3)?.removeFromSuperview()
    }
    
    @objc func showArticle() {
        guard let id = self.id else { return }
        delegate?.cellClicked(with: id)
    }
}
