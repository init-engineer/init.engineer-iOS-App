//
//  ReviewViewController.swift
//  init.engineer-iOS-App
//
//  Created by horo on 2/8/21.
//  Copyright © 2021 Kantai Developer. All rights reserved.
//

import UIKit
import KaobeiAPI
import GoogleMobileAds

class ReviewViewController: UIViewController {
    var reloadBlock: (() -> ())?
    var id: Int?
    
    
    
    @objc func hitVote() {
        self.reloadBlock?()
    }
}
