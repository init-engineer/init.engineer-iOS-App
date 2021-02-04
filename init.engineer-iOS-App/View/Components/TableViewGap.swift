//
//  TableViewGap.swift
//  init.engineer-iOS-App
//
//  Created by Chen, Yuting | Eric | RP on 2021/02/01.
//  Copyright © 2021 Kantai Developer. All rights reserved.
//

import UIKit

class TableViewGap: UITableViewHeaderFooterView {
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        self.isHidden = true
    }
}
