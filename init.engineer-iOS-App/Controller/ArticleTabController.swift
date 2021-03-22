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
import NVActivityIndicatorView

class ArticleTabController: UIViewController {
    
    @IBOutlet weak var articleTable: UITableView!
    var articleList = [Article?]()
    var count = 1
    var adBanner = GADBannerView(adSize: kGADAdSizeMediumRectangle)
    var interstitial = GADInterstitial(adUnitID: K.getInfoPlistByKey("GAD AdsInterstitial") ?? "")
    
    var loadingView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), type: .randomPick(), color: .cyan, padding: .none)
    let refreshControl = UIRefreshControl()
    
    let GAP_ID = "gap"
    let ARTICLE_ID = "article"
    let TITLE_ID = "title"
    
    var reloadBlocker = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.adBanner.adUnitID = K.getInfoPlistByKey("GAD Cell1") ?? ""
        self.adBanner.rootViewController = self
        self.adBanner.load(GADRequest())
        
        self.interstitial.load(GADRequest())
        
        self.articleTable.allowsSelection = true
        self.articleTable.delegate = self
        self.articleTable.dataSource = self
        self.articleTable.backgroundColor = .clear
        self.articleTable.sectionHeaderHeight = 20.0
        self.articleTable.register(ArticleCell.self, forCellReuseIdentifier: ARTICLE_ID)
        self.articleTable.register(TableViewTitle.self, forCellReuseIdentifier: TITLE_ID)
        self.articleTable.register(TableViewGap.self, forHeaderFooterViewReuseIdentifier: GAP_ID)
        self.articleList.append(nil)
        self.articleTable.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshArticles), for: .valueChanged)
        
        self.loadingView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.loadingView)
        NSLayoutConstraint.init(item: self.loadingView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint.init(item: self.loadingView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1.0, constant: 0.0).isActive = true
        
        reloadBlocker = true
        let listRequest = KBGetArticleList.init(page: count)
        self.loadingView.startAnimating()
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
            
            DispatchQueue.main.async {
                self?.loadingView.stopAnimating()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    @objc func refreshArticles() {
        self.reloadBlocker = true
        
        let listRequest = KBGetArticleList.init(page: 1)
        
        KaobeiConnection.sendRequest(api: listRequest) { [weak self] response in
            self?.reloadBlocker = false
            switch response.result {
            case .success(let data):
                self?.articleList.removeAll()
                self?.articleList.append(nil)
                self?.articleList.append(contentsOf: data.data)
                self?.articleList.append(nil)
                self?.articleTable.reloadData()
                self?.count = 2
                break
            case .failure(let error):
                print(error.responseCode ?? "")
                break
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self?.refreshControl.endRefreshing()
                self?.articleTable.reloadData()
            }
        }
    }
}

extension ArticleTabController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return articleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = self.articleTable.dequeueReusableCell(withIdentifier: TITLE_ID) as! TableViewTitle
            cell.setupUI(with: "文章列表 Article")
            cell.selectionStyle = .none
            return cell
        }
        
        let cell = self.articleTable.dequeueReusableCell(withIdentifier: ARTICLE_ID) as! ArticleCell
        cell.selectionStyle = .none
        if let article = articleList[indexPath.section] {
            cell.makeArticle(content: article)
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
                    if data.meta.pagination.count == 0 {
                        self?.reloadBlocker = true
                        break
                    }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let id = articleList[indexPath.section]?.id else {
            return
        }
        
        if let vc = UIStoryboard.init(name: "ArticleDetailView", bundle: nil).instantiateViewController(identifier: "ArticleViewController") as? ArticleViewController {
            vc.articleID = id
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
