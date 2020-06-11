//
//  IndexTabController.swift
//  init.engineer-iOS-App
//
//  Created by 乾太 on 2020/4/20.
//  Renamed by horowolf on 2020/6/6. 歷史見證日
//  Copyright © 2020 Kantai Developer. All rights reserved.
//

import UIKit
import SafariServices

class IndexTabController: UIViewController, SFSafariViewControllerDelegate {

    @IBOutlet weak var turnipCalculatorImg: UIImageView!
    @IBOutlet weak var facebookImg: UIImageView!
    @IBOutlet weak var twitterImg: UIImageView!
    @IBOutlet weak var plurkImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func kohlrabiButtonPressed(_ sender: UIButton) {
        let urlString = "https://kaobei.engineer/animal/kohlrabi"

        if let url = URL(string: urlString) {
            let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            vc.delegate = self

            present(vc, animated: true)
        }
    }
    @IBAction func facebookButtonPressed(_ sender: UIButton) {
        let urlString = "https://www.facebook.com/init.kobeengineer"

        if let url = URL(string: urlString) {
            let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            vc.delegate = self

            present(vc, animated: true)
        }
    }
    @IBAction func twitterButtonPressed(_ sender: UIButton) {
        let urlString = "https://twitter.com/kaobei_engineer"

        if let url = URL(string: urlString) {
            let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            vc.delegate = self

            present(vc, animated: true)
        }
    }
    @IBAction func plurkButtonPressed(_ sender: UIButton) {
        let urlString = "https://www.plurk.com/kaobei_engineer"

        if let url = URL(string: urlString) {
            let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            vc.delegate = self

            present(vc, animated: true)
        }
    }
    
    
}

