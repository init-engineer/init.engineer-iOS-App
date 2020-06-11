//
//  ArticleViewController.swift
//  init.engineer-iOS-App
//
//  Created by horo on 6/7/20.
//  Copyright © 2020 Kantai Developer. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController {
    @IBOutlet weak var articleImg: UIImageView!
    @IBOutlet weak var articleText: UITextView!
    @IBOutlet weak var publishTimeLabel: UILabel!
    @IBOutlet weak var anonymousImg: UIImageView!
    @IBOutlet weak var anonymousLabel: UILabel!
    @IBOutlet weak var mainFBLikeLabel: UILabel!
    @IBOutlet weak var alterFBLikeLabel: UILabel!
    @IBOutlet weak var plurkLikeLabel: UILabel!
    @IBOutlet weak var twitterLikeLabel: UILabel!
    @IBOutlet weak var mainFBShareLabel: UILabel!
    @IBOutlet weak var alterFBShareLabel: UILabel!
    @IBOutlet weak var plurkShareLabel: UILabel!
    @IBOutlet weak var twitterShareLabel: UILabel!
    @IBOutlet weak var commentListView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
}
