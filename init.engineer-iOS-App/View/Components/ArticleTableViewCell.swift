//
//  ArticleTableViewCell.swift
//  init.engineer-iOS-App
//
//  Created by 楊承昊 on 2021/2/11.
//  Copyright © 2021 Kantai Developer. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {

    @IBOutlet weak var articleCellView: UIView!
    @IBOutlet weak var articleContentLabel: UILabel!
    @IBOutlet weak var articleIDLabel: UILabel!
    @IBOutlet weak var articleCreatedTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        articleCellView.layer.cornerRadius = 10
        articleCellView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
