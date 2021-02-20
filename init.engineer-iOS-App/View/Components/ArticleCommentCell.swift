//
//  ArticleCommentCell.swift
//  init.engineer-iOS-App
//
//  Created by 楊承昊 on 2021/2/13.
//  Copyright © 2021 Kantai Developer. All rights reserved.
//

import UIKit
import KaobeiAPI

class ArticleCommentCell: UIView {
    
    let mainCard = UIView()
    let mainStackView = UIStackView()
    let userAvatarImageView = UIImageView()
    let userAllContentWithoutAvatar = UIStackView()
    let userNameAndPlatformStackView = UIStackView()
    let commentBubble = UIView()
    let createdTimeStackView = UIStackView()
    let userNameLabel = UILabel()
    let platformLabel = UILabel()
    let commentLabel = UILabel()
    let createdTimeLabel = UILabel()
    var comment: Comment?
    
    func renderComment(with comment: Comment) {
        self.comment = comment
        mainCard.translatesAutoresizingMaskIntoConstraints = false
        mainCard.backgroundColor = .clear
        self.addSubview(mainCard)
        self.addConstraints([
            mainCard.topAnchor.constraint(equalTo: self.topAnchor),
            mainCard.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            mainCard.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mainCard.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
        
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.axis = .horizontal
        mainStackView.alignment = .top
        mainStackView.distribution = .fill
        mainStackView.spacing = 20.0
        
        mainCard.addSubview(mainStackView)
        mainCard.addConstraints([
            mainStackView.topAnchor.constraint(equalTo: mainCard.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: mainCard.bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: mainCard.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: mainCard.trailingAnchor)
        ])
        
        
        setUserAvatarImageView()
        setUserAllContentWithoutAvatar()
        
        mainStackView.addArrangedSubview(userAvatarImageView)
        mainStackView.addArrangedSubview(userAllContentWithoutAvatar)
        setUserNameAndPlatformStackView()
        
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.text = comment.name
//        userNameLabel.textColor = ColorConstants.Card.whiteTextColor
        
        platformLabel.translatesAutoresizingMaskIntoConstraints = false
//        platformLabel.textColor = ColorConstants.Card.whiteTextColor
        
        
        userNameAndPlatformStackView.addArrangedSubview(userNameLabel)
        userNameAndPlatformStackView.addArrangedSubview(platformLabel)
        
        setCommentBubble()
        setPlatform()
        setCreatedTimeStackView()
        
        userAllContentWithoutAvatar.addArrangedSubview(userNameAndPlatformStackView)
        userAllContentWithoutAvatar.addArrangedSubview(commentBubble)
        userAllContentWithoutAvatar.addArrangedSubview(createdTimeStackView)
    }
    
    private func setUserAvatarImageView() {
        guard let comment = self.comment else {
            return
        }
        userAvatarImageView.translatesAutoresizingMaskIntoConstraints = false
        userAvatarImageView.image = UIImage(named: "no_avatar")
        userAvatarImageView.layer.cornerRadius = 10
        userAvatarImageView.layer.masksToBounds = true
        let userAvatarImageViewWidthConstraint = NSLayoutConstraint(item: userAvatarImageView, attribute: .width, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 50.0)
        let userAvatarImageViewHeightConstraint = NSLayoutConstraint(item: userAvatarImageView, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 50.0)
        userAvatarImageView.addConstraints([
            userAvatarImageViewWidthConstraint,
            userAvatarImageViewHeightConstraint
        ])
        if comment.avatar != "/img/frontend/user/nopic_192.gif" {
            DispatchQueue.main.async {
                do {
                    let commentUserAvatarImage = try UIImage(data: Data(contentsOf: URL(string: comment.avatar)!))
                    DispatchQueue.main.async {
                        self.userAvatarImageView.image = commentUserAvatarImage
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
    
    private func setUserAllContentWithoutAvatar() {
        userAllContentWithoutAvatar.translatesAutoresizingMaskIntoConstraints = false
        userAllContentWithoutAvatar.axis = .vertical
        userAllContentWithoutAvatar.alignment = .fill
        userAllContentWithoutAvatar.distribution = .fill
        userAllContentWithoutAvatar.spacing = 5
    }
    
    private func setUserNameAndPlatformStackView() {
        userNameAndPlatformStackView.translatesAutoresizingMaskIntoConstraints = false
        userNameAndPlatformStackView.axis = .horizontal
        userNameAndPlatformStackView.alignment = .fill
        userNameAndPlatformStackView.distribution = .equalSpacing
    }
    
    private func setCommentBubble() {
        guard let comment = self.comment else {
            return
        }
        commentBubble.translatesAutoresizingMaskIntoConstraints = false
        commentBubble.backgroundColor = ColorConstants.Comment.bubbleColor
        commentBubble.layer.cornerRadius = 9
        commentBubble.layer.masksToBounds = true
        
        
        
        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        commentLabel.numberOfLines = 0
        commentLabel.textColor = ColorConstants.Card.whiteTextColor
        commentLabel.text = comment.content
        commentBubble.addSubview(commentLabel)
        commentBubble.addConstraints([
            commentLabel.topAnchor.constraint(equalTo: commentBubble.topAnchor, constant: 10),
            commentLabel.bottomAnchor.constraint(equalTo: commentBubble.bottomAnchor, constant: -10),
            commentLabel.leadingAnchor.constraint(equalTo: commentBubble.leadingAnchor, constant: 10),
            commentLabel.trailingAnchor.constraint(equalTo: commentBubble.trailingAnchor, constant: -10)
        ])
    }
    
    private func setCreatedTimeStackView() {
        guard let comment = self.comment else {
            return
        }
        createdTimeStackView.translatesAutoresizingMaskIntoConstraints = false
        createdTimeStackView.axis = .horizontal
        createdTimeStackView.alignment = .top
        createdTimeStackView.distribution = .fill
        
//        createdTimeLabel.textColor = ColorConstants.Card.whiteTextColor
        createdTimeLabel.text = comment.created
        createdTimeStackView.addArrangedSubview(createdTimeLabel)
    }
    
    private func setPlatform() {
        guard let comment = self.comment else {
            return
        }
        if comment.media.type == "plurk" {
            commentBubble.backgroundColor = .systemRed
            platformLabel.text = "Plurk"
        }
        else if comment.media.type == "twitter" {
            commentBubble.backgroundColor = .systemTeal
            platformLabel.text = "Twitter"
        }
        else if comment.media.type == "facebook" {
            commentBubble.backgroundColor = .systemBlue
            if comment.media.connections == "primary" {
                platformLabel.text = "Facebook 主站"
            }
            else if comment.media.connections == "secondary" {
                platformLabel.text = "Facebook 次站"
            }
        }
    }

}
