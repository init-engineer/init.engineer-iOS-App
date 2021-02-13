//
//  ProfileCell.swift
//  init.engineer-iOS-App
//
//  Created by 楊承昊 on 2021/2/14.
//  Copyright © 2021 Kantai Developer. All rights reserved.
//

import UIKit
import KaobeiAPI

class ProfileCell: UITableViewCell {
    
    let mainStack = UIStackView()
    let rightStack = UIStackView()
    let userAvatarImageView = UIImageView()
    let userNameLabel = UILabel()
    let userEmailLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func insert(with user: KBGetUserProfile, reload: @escaping () -> ()) {
        self.backgroundColor = .clear
        KaobeiConnection.sendRequest(api: user) { [weak self] response in
            switch response.result {
            case .success(let data):
                self?.setupUI()
                self?.userNameLabel.text = data.data.fullName
                self?.userEmailLabel.text = data.data.email
                DispatchQueue.global(qos: .userInitiated).async {
                    do {
                        let userAvatarImage = try UIImage(data: Data(contentsOf: URL(string: data.data.avatar)!))
                        DispatchQueue.main.async {
                            self?.userAvatarImageView.image = userAvatarImage
                            reload()
                        }
                    } catch is Error {

                    }
                }
                break
            case .failure(let error):
                print(error.responseCode ?? "")
                break
            }
        }
    }
    
    func setupUI() {
        
        self.backgroundColor = .clear
        
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        mainStack.axis = .horizontal
        mainStack.alignment = .fill
        mainStack.distribution = .fillProportionally
        mainStack.spacing = 20.0
        contentView.addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        rightStack.translatesAutoresizingMaskIntoConstraints = false
        rightStack.axis = .vertical
        rightStack.alignment = .fill
        rightStack.distribution = .fillEqually
        
        userAvatarImageView.addConstraints([
            NSLayoutConstraint(item: userAvatarImageView, attribute: .width, relatedBy: .equal, toItem: userAvatarImageView, attribute: .height, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: userAvatarImageView, attribute: .width, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 100.0)
        ])
        userAvatarImageView.layer.cornerRadius = 10
        userAvatarImageView.clipsToBounds = true
        
        mainStack.addArrangedSubview(userAvatarImageView)
        mainStack.addArrangedSubview(rightStack)
        rightStack.addArrangedSubview(userNameLabel)
        rightStack.addArrangedSubview(userEmailLabel)
        
//        userNameLabel.text = userName
        userNameLabel.font = FontConstant.Dashboard.userName
        userNameLabel.textColor = ColorConstants.Dashboard.userName
        
//        userEmailLabel.text = userEmail
        userEmailLabel.font = FontConstant.Dashboard.userEmail
        userEmailLabel.textColor = ColorConstants.Dashboard.userEmail
    }
    
}
