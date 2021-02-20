//
//  ReviewCell.swift
//  init.engineer-iOS-App
//
//  Created by horo on 2021/02/12.
//  Copyright © 2021 Kantai Developer. All rights reserved.
//

import UIKit
import GoogleMobileAds
import KaobeiAPI

protocol ReviewCellDelegate {
    func cellClicked(aye: Int, nay: Int, review: Int, and article: ArticleUnderReview?, updateCompletion: ((Int, Int, Int) -> ())?)
}

class ReviewCell: UITableViewCell {
    var contentString: String?
    var stringTag: String?
    var publishTime: String?
    var enterArticleBtn: UIButton?
    var vote: Int?
    var aye: Int?
    var nay: Int?
    var review: Int?
    var id: Int?
    var reviewingArticle: ArticleUnderReview?
    var delegate: ReviewCellDelegate?
    var ayeLabel = UILabel()
    var voteLabel = UILabel()
    var nayLabel = UILabel()
    
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
    
    func makeArticleInReview(content: ArticleUnderReview) {
        dispatchViews()
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 10
        self.id = content.id
        self.reviewingArticle = content
        self.stringTag = String.tagConvert(from: content.id)
        self.publishTime = content.createdDiff
        self.contentString = content.content
        self.backgroundColor = .clear
        self.aye = content.succeeded
        self.nay = content.failed
        self.vote = content.succeeded + content.failed
        self.review = content.review
        
        makeUI()
    }
    
    private func makeUI() {
        let upperView = UIView()
        let bottomView = UIView()
        
        upperView.tag = 2
        bottomView.tag = 3
        
        upperView.backgroundColor = ColorConstants.Card.backgroundColor
        bottomView.backgroundColor = .white
        
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
        
        let bottomStackView = UIStackView()
        bottomStackView.axis = .horizontal
        bottomStackView.distribution = .equalSpacing
        bottomStackView.alignment = .center
        
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        
        bottomStackView.addArrangedSubview(tagLabel)
        bottomStackView.addArrangedSubview(timeLabel)
        bottomStackView.addArrangedSubview(enterArticleBtn)
        
        self.ayeLabel = UILabel()
        self.voteLabel = UILabel()
        self.nayLabel = UILabel()
        guard let review = self.review, let aye = self.aye, let vote = self.vote, let nay = self.nay else { return }
        if review == 0 {
            self.ayeLabel.text = "==="
            self.voteLabel.text = "==="
            self.nayLabel.text = "==="
        } else {
            self.ayeLabel.text = "\(aye)"
            self.voteLabel.text = "\(vote)"
            self.nayLabel.text = "\(nay)"
        }
        self.ayeLabel.font = FontConstant.Default.text
        self.voteLabel.font = FontConstant.Default.text
        self.nayLabel.font = FontConstant.Default.text
        self.ayeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.voteLabel.translatesAutoresizingMaskIntoConstraints = false
        self.nayLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let upperStackView = UIStackView()
        upperStackView.axis = .horizontal
        upperStackView.distribution = .equalSpacing
        upperStackView.alignment = .center
        
        upperStackView.translatesAutoresizingMaskIntoConstraints = false
        
        upperStackView.addArrangedSubview(self.ayeLabel)
        upperStackView.addArrangedSubview(self.voteLabel)
        upperStackView.addArrangedSubview(self.nayLabel)
        
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
    }
    
    func dispatchViews() {
        contentView.viewWithTag(1)?.removeFromSuperview()
        contentView.viewWithTag(2)?.removeFromSuperview()
        contentView.viewWithTag(3)?.removeFromSuperview()
    }
    
    @objc func showArticle() {
        guard let aye = self.aye, let nay = self.nay, let review = self.review else { return }
        delegate?.cellClicked(aye: aye, nay: nay, review: review, and: self.reviewingArticle) {[weak self] (aye, nay, review) in
            self?.aye = aye
            self?.nay = nay
            self?.vote = aye + nay
            self?.review = review
            self?.ayeLabel.text = "\(aye)"
            self?.voteLabel.text = "\(aye + nay)"
            self?.nayLabel.text = "\(nay)"
        }
    }
}
