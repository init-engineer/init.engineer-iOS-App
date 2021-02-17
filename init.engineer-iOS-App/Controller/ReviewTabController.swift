//
//  ReviewTabController.swift
//  init.engineer-iOS-App
//
//  Created by 楊承昊 on 2021/1/29.
//  Copyright © 2021 Kantai Developer. All rights reserved.
//

import UIKit
import KaobeiAPI
import GoogleMobileAds
import NVActivityIndicatorView

class ReviewTabController: UIViewController {
    
    var userToken: String?
    @IBOutlet weak var reviewTable: UITableView!
    var reviewList = [ArticleUnderReview?]()
    var count = 1
    var adBanner = GADBannerView(adSize: kGADAdSizeMediumRectangle)
    var interstitial = GADInterstitial(adUnitID: K.getInfoPlistByKey("GAD AdsInterstitial") ?? "")
    
    var loadingView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), type: .randomPick(), color: .cyan, padding: .none)
    let GAP_ID = "gap"
    let REVIEW_ID = "review"
    let TITLE_ID = "title"
    
    var reloadBlocker = false
    var cellBlock: ((Int, Int) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        if let accessToken = KeyChainManager.shared.getToken() {
            self.userToken = accessToken
            print(accessToken)
            if self.reviewList.count > 0 {
                return
            }
            
            self.adBanner.adUnitID = K.getInfoPlistByKey("GAD Cell2") ?? ""
            self.adBanner.rootViewController = self
            self.adBanner.load(GADRequest())
            
            self.interstitial.load(GADRequest())
            
            self.reviewTable.allowsSelection = false
            self.reviewTable.delegate = self
            self.reviewTable.dataSource = self
            self.reviewTable.backgroundColor = .clear
            self.reviewTable.sectionHeaderHeight = 20.0
            self.reviewTable.register(ReviewCell.self, forCellReuseIdentifier: REVIEW_ID)
            self.reviewTable.register(TableViewTitle.self, forCellReuseIdentifier: TITLE_ID)
            self.reviewTable.register(TableViewGap.self, forHeaderFooterViewReuseIdentifier: GAP_ID)
            self.reviewList.append(nil)
            
            self.loadingView.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(self.loadingView)
            NSLayoutConstraint.init(item: self.loadingView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0.0).isActive = true
            NSLayoutConstraint.init(item: self.loadingView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1.0, constant: 0.0).isActive = true
            
            reloadBlocker = true
            let listRequest = KBGetArticleReviewList.init(accessToken: accessToken, page: count)
            self.loadingView.startAnimating()
            KaobeiConnection.sendRequest(api: listRequest) { [weak self] response in
                self?.reloadBlocker = false
                switch response.result {
                case .success(let data):
                    self?.reviewList.append(contentsOf: data.data)
                    self?.reviewList.append(nil)
                    self?.reviewTable.reloadData()
                    self?.count += 1
                    break
                case .failure(let error):
                    print(error.responseCode ?? "")
                    self?.reviewList.append(nil)
                    self?.reviewTable.reloadData()
                    break
                }
                
                DispatchQueue.main.async {
                    self?.loadingView.stopAnimating()
                }
            }
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
            return cell
        }
        
        let cell = self.reviewTable.dequeueReusableCell(withIdentifier: REVIEW_ID) as! ReviewCell
        if let review = reviewList[indexPath.section] {
            cell.makeArticleInReview(content: review)
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
        guard let userToken = self.userToken else { return }
        
        if indexPath.section >= self.reviewList.count - 2 {
            reloadBlocker = true
            let listRequest = KBGetArticleReviewList.init(accessToken: userToken, page: count)
            KaobeiConnection.sendRequest(api: listRequest) { [weak self] response in
                self?.reloadBlocker = false
                switch response.result {
                case .success(let data):
                    if data.meta.pagination.count == 0 {
                        self?.reloadBlocker = true
                        break
                    }
                    self?.reviewList.append(contentsOf: data.data)
                    self?.reviewList.append(nil)
                    self?.reviewTable.reloadData()
                    self?.count += 1
                    break
                case .failure(let error):
                    print(error.responseCode ?? "")
                    self?.reviewList.append(nil)
                    self?.reviewTable.reloadData()
                    break
                }
            }
        }
    }
}

extension ReviewTabController: ReviewCellDelegate {
    func cellClicked(with id: Int, and article: ArticleUnderReview?, updateCompletion: ((Int, Int) -> ())?) {
        guard let article = article, let block = updateCompletion else { return }
        if self.interstitial.isReady {
            self.interstitial.present(fromRootViewController: self)
        }
        self.cellBlock = block
        self.performSegue(withIdentifier: K.ToReviewDetailsSegue, sender: article)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.ToReviewDetailsSegue {
            guard let vc = segue.destination as? ReviewDetailViewController, let article = sender as? ArticleUnderReview else { return }
            vc.id = article.id
            vc.reviewStatus = article
            vc.reloadBlock = self.cellBlock
        }
    }
}
