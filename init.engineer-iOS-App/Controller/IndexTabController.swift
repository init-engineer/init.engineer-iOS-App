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
import AppTrackingTransparency

class IndexTabController: UIViewController, SFSafariViewControllerDelegate, IndexButtonCellDelegate {

    @IBOutlet weak var indexStackView: UIStackView!
    let indexPage = [
        ["線上抽籤系統", "搖ㄌㄟ搖ㄌㄟ搖", #imageLiteral(resourceName: "img_fortune"), "https://kaobei.engineer/fortunes"],
        ["大頭菜計算器", "輕鬆致富首選", #imageLiteral(resourceName: "kohlrabi"), "https://kaobei.engineer/animal/kohlrabi"],
        ["Telegram 頻道", "史上最純的頻道", #imageLiteral(resourceName: "img_telegram"), "https://t.me/init_engineer"],
        ["Facebook 粉絲頁", "Hen 純", #imageLiteral(resourceName: "img_flag1"), "https://www.facebook.com/init.kobeengineer"],
        ["Plurk 粉絲頁", "Very 純", #imageLiteral(resourceName: "img_plurk"), "https://www.plurk.com/kaobei_engineer"],
        ["Twitter 粉絲頁", "Super 純", #imageLiteral(resourceName: "img_twitter"), "https://twitter.com/kaobei_engineer"],
        ["Tumblr 粉絲頁", "湯現在不熱了", #imageLiteral(resourceName: "img_tumblr"), "https://kaobei-engineer.tumblr.com/"],
        ["MeWe 粉絲頁", "weeeeeeee~~", #imageLiteral(resourceName: "img_mewe"), "https://mewe.com/p/init.kobeengineer"],
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        for element in indexPage {
            let addView = IndexButtonCell()
            addView.title.text = element[0] as? String
            addView.subtitle.text = element[1] as? String
            addView.image.image = element[2] as? UIImage
            addView.heightAnchor.constraint(equalToConstant: 100).isActive = true
            addView.url = element[3] as! String
            addView.delegate = self
            indexStackView.addArrangedSubview(addView)
        }
        ATTRequest()
    }
    
    func indexButtonViewDelegate(urlString: String){
        if let url = URL(string: urlString) {
            let webView = SFSafariViewController(url: url)
            webView.delegate = self

            present(webView, animated: true)
        }
    }
    
    func ATTRequest() {
        if #available(iOS 14.0, *) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                print("ATT status: \(status.rawValue)")
            })
        }
    }
}

