//
//  ArticleTabController.swift
//  init.engineer-iOS-App
//
//  Created by horo on 6/6/20.
//  Copyright © 2020 Kantai Developer. All rights reserved.
//

import UIKit
import KaobeiAPI
import GoogleMobileAds

class ArticleTabController: UIViewController {
    
    @IBOutlet weak var articleTable: UITableView!
    var articleList = [Article?]()
    var count = 1
    var adBanner = GADBannerView(adSize: kGADAdSizeMediumRectangle)
    
    let GAP_ID = "gap"
    let ARTICLE_ID = "article"
    let TITLE_ID = "title"
    
    var reloadBlocker = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.adBanner.adUnitID = K.getInfoPlistByKey("GAD AdsBanner1") ?? ""
        self.adBanner.rootViewController = self
        self.adBanner.load(GADRequest())
        
        self.articleTable.allowsSelection = false
        self.articleTable.delegate = self
        self.articleTable.dataSource = self
        self.articleTable.backgroundColor = .clear
        self.articleTable.sectionHeaderHeight = 20.0
        self.articleTable.register(ArticleCell.self, forCellReuseIdentifier: ARTICLE_ID)
        self.articleTable.register(TableViewTitle.self, forCellReuseIdentifier: TITLE_ID)
        self.articleTable.register(TableViewGap.self, forHeaderFooterViewReuseIdentifier: GAP_ID)
        self.articleList.append(nil)
        
        reloadBlocker = true
        let listRequest = KBGetArticleList.init(page: count)
        KaobeiConnection.sendRequest(api: listRequest) { [weak self] response in
            self?.reloadBlocker = false
            switch response.result {
            case .success(let data):
                self?.articleList.append(contentsOf: data.data)
                self?.articleList.append(nil)
                self?.articleTable.reloadData()
                self?.count += 1
                break
            case .failure(let error):
                print(error.responseCode ?? "")
                self?.articleList.append(nil)
                self?.articleTable.reloadData()
                break
            }
        }
    }


}

extension ArticleTabController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        articleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = self.articleTable.dequeueReusableCell(withIdentifier: TITLE_ID) as! TableViewTitle
            //cell.setupUI()
            return cell
        }
        
        let cell = self.articleTable.dequeueReusableCell(withIdentifier: ARTICLE_ID) as! ArticleCell
        if let article = articleList[indexPath.section] {
            cell.makeArticel(content: article)
        } else {
            cell.makeAds(ads: self.adBanner)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: GAP_ID) as! TableViewGap
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return tableView.sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if reloadBlocker == true { return }
        if indexPath.section >= self.articleList.count - 2 {
            reloadBlocker = true
            let listRequest = KBGetArticleList.init(page: count)
            KaobeiConnection.sendRequest(api: listRequest) { [weak self] response in
                self?.reloadBlocker = false
                switch response.result {
                case .success(let data):
                    self?.articleList.append(contentsOf: data.data)
                    self?.articleList.append(nil)
                    self?.articleTable.reloadData()
                    self?.count += 1
                    break
                case .failure(let error):
                    print(error.responseCode ?? "")
                    self?.articleList.append(nil)
                    self?.articleTable.reloadData()
                    break
                }
            }
        }
    }
}

