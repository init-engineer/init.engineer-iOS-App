//
//  ArticleCommentTableViewCell.swift
//  init.engineer-iOS-App
//
//  Created by 楊承昊 on 2021/2/10.
//  Copyright © 2021 Kantai Developer. All rights reserved.
//

import UIKit

class ArticleCommentTableViewCell: UITableViewCell {

    @IBOutlet weak var commentBubble: UIView!
    @IBOutlet weak var commentUserAvaratImageView: UIImageView!
    @IBOutlet weak var commentUserNameLabel: UILabel!
    @IBOutlet weak var commentPlatformLabel: UILabel!
    @IBOutlet weak var commentCreateTimeLabel: UILabel!
    @IBOutlet weak var commentUserContentLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        commentBubble.layer.cornerRadius = commentBubble.frame.size.height / 5
        commentUserAvaratImageView.layer.cornerRadius = 10
        commentUserAvaratImageView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
