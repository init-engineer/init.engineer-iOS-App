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
    
    let HEADER_ID = "header"
    let ARTICLE_ID = "article"
    let TITLE_ID = "title"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.adBanner.adUnitID = K.getInfoPlistByKey("GAD AdsBanner1") ?? ""
        self.adBanner.rootViewController = self
        self.adBanner.load(GADRequest())
        
        self.articleTable.delegate = self
        self.articleTable.dataSource = self
        self.articleTable.backgroundColor = .clear
        self.articleTable.sectionHeaderHeight = 20.0
        self.articleTable.backgroundView?.backgroundColor = .yellow
        self.articleTable.register(ArticleCell.self, forCellReuseIdentifier: ARTICLE_ID)
        self.articleTable.register(ArticleHeader.self, forCellReuseIdentifier: TITLE_ID)
        self.articleTable.register(ArticleGap.self, forHeaderFooterViewReuseIdentifier: HEADER_ID)
        self.articleList.append(nil)
        
        let listRequest = KBGetArticleList.init(page: count)
        KaobeiConnection.sendRequest(api: listRequest) { [weak self] response in
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
            let cell = self.articleTable.dequeueReusableCell(withIdentifier: TITLE_ID) as! ArticleHeader
            cell.setupUI()
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
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: HEADER_ID) as! ArticleGap
        header.setupUI()
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return tableView.sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section >= self.articleList.count - 1 {
            let listRequest = KBGetArticleList.init(page: count)
            KaobeiConnection.sendRequest(api: listRequest) { [weak self] response in
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



fileprivate class ArticleHeader: UITableViewCell {
    let title = "文章列表 Article"
    
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

fileprivate class ArticleGap: UITableViewHeaderFooterView {
    
    func setupUI() {
        self.isHidden = true
    }
}
