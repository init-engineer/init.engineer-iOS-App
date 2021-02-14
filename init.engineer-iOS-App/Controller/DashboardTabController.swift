//
//  DashboardTabController.swift
//  init.engineer-iOS-App
//
//  Created by horo on 6/6/20.
//  Copyright © 2020 Kantai Developer. All rights reserved.
//

import UIKit
import KaobeiAPI
import GoogleMobileAds

class DashboardTabController: UIViewController, GADBannerViewDelegate {
    
    @IBOutlet weak var userPostsTableView: UITableView!
    var adBanner = GADBannerView(adSize: kGADAdSizeMediumRectangle)
    var interstitial = GADInterstitial(adUnitID: K.getInfoPlistByKey("GAD AdsInterstitial") ?? "")
    var userPosts = [Post?]()
    var userToken: String?
    var reloadBlocker = false
    
    var currentPage = 1
    
    let GAP_ID = "gap"
    let ARTICLE_ID = "article"
    let TITLE_ID = "title"
    let PROFILE_ID = "profile"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.adBanner.adUnitID = K.getInfoPlistByKey("GAD Cell1") ?? ""
        self.adBanner.rootViewController = self
        self.adBanner.load(GADRequest())
        self.interstitial.load(GADRequest())
        
        self.userPostsTableView.allowsSelection = false
        self.userPostsTableView.delegate = self
        self.userPostsTableView.dataSource = self
        self.userPostsTableView.backgroundColor = .clear
        self.userPostsTableView.sectionHeaderHeight = 20.0
        self.userPostsTableView.register(ArticleCell.self, forCellReuseIdentifier: ARTICLE_ID)
        self.userPostsTableView.register(TableViewTitle.self, forCellReuseIdentifier: TITLE_ID)
        self.userPostsTableView.register(ProfileCell.self, forCellReuseIdentifier: PROFILE_ID)
        self.userPostsTableView.register(TableViewGap.self, forHeaderFooterViewReuseIdentifier: GAP_ID)
        self.userPosts.append(nil)
        self.userPosts.append(nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        if let accessToken = KeyChainManager.shared.getToken() {
            self.userToken = accessToken
            
            reloadBlocker = true
            let getUserPostsRequest = KBGetUserPosts(accessToken: accessToken)
            KaobeiConnection.sendRequest(api: getUserPostsRequest) { [weak self] response in
                self?.reloadBlocker = false
                switch response.result {
                case .success(let data):
                    self?.userPosts.append(contentsOf: data.data)
                    self?.userPosts.append(nil)
                    self?.userPostsTableView.reloadData()
                    self?.currentPage += 1
                    break
                case .failure(let error):
                    print(error.responseCode ?? "")
                    self?.userPosts.append(nil)
                    self?.userPostsTableView.reloadData()
                    break
                }
            }
        }
        else {
            self.performSegue(withIdentifier: K.dashboardToLoginSegue, sender: self)
        }
    }
    
    
    @objc func showSettingActionSheet(sender: UITapGestureRecognizer) {
        let controller = UIAlertController(title: "", message: "你確定你要登出嗎？", preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "登出", style: .destructive, handler: logout)
        controller.addAction(action)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
    }
    
    func logout(_ action: UIAlertAction) { // Logout action
        KeyChainManager.shared.deleteToken()
        self.performSegue(withIdentifier: K.dashboardToLoginSegue, sender: self)
    }
}

extension DashboardTabController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return userPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = self.userPostsTableView.dequeueReusableCell(withIdentifier: TITLE_ID) as! TableViewTitle
            cell.setupUI(with: "儀表板 Dashboard")
            return cell
        } else if indexPath.section == 1 {
            let cell = self.userPostsTableView.dequeueReusableCell(withIdentifier: PROFILE_ID) as! ProfileCell
            if let userToken = self.userToken {
                let getUserProfileRequest = KBGetUserProfile.init(accessToken: userToken)
                cell.setup(with: getUserProfileRequest, reload: self.userPostsTableView.reloadData)
                let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.showSettingActionSheet))
                cell.addGestureRecognizer(gesture)
                return cell
            }
        }
        
        let cell = self.userPostsTableView.dequeueReusableCell(withIdentifier: ARTICLE_ID) as! ArticleCell
        if let post = userPosts[indexPath.section] {
            cell.makePost(content: post)
            cell.delegate = self
        } else {
            cell.makeAds(ads: self.adBanner)
            cell.delegate = nil
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
        if indexPath.section >= self.userPosts.count - 2 {
            reloadBlocker = true
            guard let userToken = self.userToken else { return }
            let listRequest = KBGetUserPosts.init(accessToken: userToken, page: currentPage)
            KaobeiConnection.sendRequest(api: listRequest) { [weak self] response in
                self?.reloadBlocker = false
                switch response.result {
                case .success(let data):
                    if data.meta.pagination.count == 0 {
                        self?.reloadBlocker = true
                        break
                    }
                    self?.userPosts.append(contentsOf: data.data)
                    self?.userPosts.append(nil)
                    self?.userPostsTableView.reloadData()
                    self?.currentPage += 1
                    break
                case .failure(let error):
                    print(error.responseCode ?? "")
                    self?.userPosts.append(nil)
                    self?.userPostsTableView.reloadData()
                    break
                }
            }
        }
    }
}

extension DashboardTabController: ArticleCellDelegate {
    func cellClicked(with id: Int) {
        if self.interstitial.isReady {
            self.interstitial.present(fromRootViewController: self)
        }
        self.performSegue(withIdentifier: K.ToArticleDetailsSegue, sender: id)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.ToArticleDetailsSegue {
            guard let vc = segue.destination as? ArticleViewController, let id = sender as? Int else { return }
            vc.articleID = id
        }
    }
}


extension DashboardTabController {
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
          [NSLayoutConstraint(item: bannerView,
                              attribute: .bottom,
                              relatedBy: .equal,
                              toItem: bottomLayoutGuide,
                              attribute: .top,
                              multiplier: 1,
                              constant: 0),
           NSLayoutConstraint(item: bannerView,
                              attribute: .centerX,
                              relatedBy: .equal,
                              toItem: view,
                              attribute: .centerX,
                              multiplier: 1,
                              constant: 0)
          ])
       }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        addBannerViewToView(bannerView)
    }
}
