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
    
    var bannerView: GADBannerView!
    var userPosts = [Post?]()
    var userToken: String?
    
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userInformationStackView: UIStackView!
    @IBOutlet weak var userArticleTableView: UITableView!
    @IBOutlet weak var userArticleTableViewHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.showSettingActionSheet))
        userInformationStackView.addGestureRecognizer(gesture)
        addRadiusImageView(userAvatarImageView)
        userArticleTableView.register(UINib(nibName: K.articleTableViewCell, bundle: nil), forCellReuseIdentifier: K.articleTableViewCellIdentifier)
        userArticleTableView.backgroundColor = .clear
        userArticleTableView.delegate = self
        userArticleTableView.dataSource = self
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.userArticleTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.userArticleTableView.reloadData()
        if let accessToken = KeyChainManager.shared.getToken() {
            self.userToken = accessToken
            let getUserProfileRequest = KBGetUserProfile.init(accessToken: accessToken)
            KaobeiConnection.sendRequest(api: getUserProfileRequest) { [weak self] response in
                switch response.result {
                case .success(let data):
                    self?.userName.text = data.data.fullName
                    self?.userEmail.text = data.data.email
                    DispatchQueue.global(qos: .userInitiated).async {
                        do {
                            let userAvatarImage = try UIImage(data: Data(contentsOf: URL(string: data.data.avatar)!))
                            DispatchQueue.main.async {
                                self?.userAvatarImageView.image = userAvatarImage
                            }
                        } catch is Error {
                            
                        }
                    }
                    break
                case .failure(let error):
                    print(error.responseCode ?? "")
                    break
                }
            }
            
            let getUserPostsRequest = KBGetUserPosts(accessToken: accessToken)
            KaobeiConnection.sendRequest(api: getUserPostsRequest) { [weak self] response in
                switch response.result {
                case .success(let data):
                    for element in data.data {
                        self?.userPosts.append(element)
                    }
                    break
                case .failure(let error):
                    print(error.responseCode ?? "")
                    break
                }
            }
        }
        else {
            self.performSegue(withIdentifier: K.dashboardToLoginSegue, sender: self)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.userArticleTableView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            if keyPath == "contentSize" {
                if object is UITableView {
                    if let newValue = change?[.newKey] {
                        let newSize = newValue as! CGSize
                        self.userArticleTableViewHeight.constant = newSize.height
                    }
                }
            }
        }
    
    func addRadiusImageView(_ iv: UIImageView) {
        iv.layer.cornerRadius = 10
        iv.clipsToBounds = true
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
    
    func setupUI() {
        // In this case, we instantiate the banner with desired ad size.
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.adUnitID = K.getInfoPlistByKey("GAD AdsBanner1") ?? ""
        bannerView.rootViewController = self
        bannerView.delegate = self
        bannerView.load(GADRequest())
        //addBannerViewToView(bannerView)
        
    }
}

extension DashboardTabController: UITableViewDelegate {
    
}

extension DashboardTabController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return userPosts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.articleTableViewCellIdentifier, for: indexPath) as! ArticleTableViewCell
        cell.articleContentLabel.text = userPosts[indexPath.row]?.content
        cell.articleIDLabel.text = K.tagConvert(from: userPosts[indexPath.row]!.id)
        cell.articleCreatedTimeLabel.text = userPosts[indexPath.row]?.createdDiff
        return cell
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
