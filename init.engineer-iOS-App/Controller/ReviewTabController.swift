//
//  ReviewTabController.swift
//  init.engineer-iOS-App
//
//  Created by 楊承昊 on 2021/1/29.
//  Copyright © 2021 Kantai Developer. All rights reserved.
//

import UIKit

import GoogleMobileAds
import NVActivityIndicatorView

class ReviewTabController: UIViewController {
    
    var userToken: String?
    @IBOutlet weak var reviewTable: UITableView!
    var reviewList = [ReviewCellData?]()
    var count = 1
    var adBanner = GADBannerView(adSize: kGADAdSizeMediumRectangle)
    var interstitial = GADInterstitial(adUnitID: K.getInfoPlistByKey("GAD AdsInterstitial") ?? "")
    
    var loadingView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), type: .randomPick(), color: .cyan, padding: .none)
    let refreshControl = UIRefreshControl()
    
    let GAP_ID = "gap"
    let REVIEW_ID = "review"
    let TITLE_ID = "title"
    
    var reloadBlocker = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        if let accessToken = KeyChainManager.shared.getToken() {
            self.userToken = accessToken
            if self.reviewList.isEmpty == false { return }
            
            self.adBanner.adUnitID = K.getInfoPlistByKey("GAD Cell2") ?? ""
            self.adBanner.rootViewController = self
            self.adBanner.load(GADRequest())
            
            self.interstitial.load(GADRequest())
            
            self.reviewTable.allowsSelection = true
            self.reviewTable.delegate = self
            self.reviewTable.dataSource = self
            self.reviewTable.backgroundColor = .clear
            self.reviewTable.sectionHeaderHeight = 20.0
            self.reviewTable.register(ReviewCell.self, forCellReuseIdentifier: REVIEW_ID)
            self.reviewTable.register(TableViewTitle.self, forCellReuseIdentifier: TITLE_ID)
            self.reviewTable.register(TableViewGap.self, forHeaderFooterViewReuseIdentifier: GAP_ID)
            self.reviewList.append(nil)
            self.reviewTable.addSubview(refreshControl)
            self.refreshControl.addTarget(self, action: #selector(refreshReviews), for: .valueChanged)
            
            self.loadingView.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(self.loadingView)
            NSLayoutConstraint.init(item: self.loadingView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0.0).isActive = true
            NSLayoutConstraint.init(item: self.loadingView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1.0, constant: 0.0).isActive = true
            
            self.loadingView.startAnimating()
            loadMoreReviewArticle()
        }
        else {
            self.userToken = nil
            self.reviewList.removeAll()
            self.reviewTable.reloadData()
            self.performSegue(withIdentifier: K.reviewToLoginSegue, sender: self)
        }
    }

    func reloadReviews() { //call when return after vote
        self.count = 1
        self.reloadBlocker = false
        self.reviewList.removeAll()
        self.loadingView.startAnimating()
        self.reviewTable.reloadData()
        self.reviewList.append(nil)
        self.loadMoreReviewArticle()
    }
    
    @objc func refreshReviews() {
        guard let userToken = self.userToken else { return }
        reloadBlocker = true
    }
    
    func loadMoreReviewArticle() {
        if reloadBlocker { return }
        guard let userToken = self.userToken else { return }
        reloadBlocker = true
    }
}
extension ReviewTabController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        reviewList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = self.reviewTable.dequeueReusableCell(withIdentifier: TITLE_ID) as! TableViewTitle
            cell.setupUI(with: "審核文章 Review")
            cell.selectionStyle = .none
            return cell
        }
        
        let cell = self.reviewTable.dequeueReusableCell(withIdentifier: REVIEW_ID) as! ReviewCell
        cell.selectionStyle = .none
        if let review = reviewList[indexPath.section] {
            cell.makeArticleInReview(content: review)
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
        
        if indexPath.section >= self.reviewList.count - 2 {
            loadMoreReviewArticle()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let reviewData = reviewList[indexPath.section] else {
            return
        }
        
        if let vc = UIStoryboard.init(name: "ReviewView", bundle: nil).instantiateViewController(identifier: "ReviewDetailViewController") as? ReviewDetailViewController,
           let cell = tableView.cellForRow(at: indexPath) as? ReviewCell {
            vc.reviewStatus = reviewData
            vc.reloadBlock = cell.updateTrigger
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
