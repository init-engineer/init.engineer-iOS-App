//
//  TableViewTitle.swift
//  init.engineer-iOS-App
//
//  Created by Chen, Yuting | Eric | RP on 2021/02/01.
//  Copyright © 2021 Kantai Developer. All rights reserved.
//

import UIKit

class TableViewTitle: UITableViewCell {
    let title = "文章列表 Article"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        let label = UILabel()
        label.text = title
        label.font = FontConstant.Default.title
        label.backgroundColor = .clear
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        self.backgroundColor = .clear
        
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
