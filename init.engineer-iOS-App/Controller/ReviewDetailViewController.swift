//
//  ReviewViewController.swift
//  init.engineer-iOS-App
//
//  Created by horo on 2/8/21.
//  Renamed by 楊承昊 on 2/9/21.
//  Copyright © 2021 Kantai Developer. All rights reserved.
//

import UIKit
import KaobeiAPI
import GoogleMobileAds
import NVActivityIndicatorView

class ReviewDetailViewController: UIViewController {
    
    @IBOutlet weak var reviewArticleTitleLabel: UILabel!
    @IBOutlet weak var reviewArticleContentTextView: KBInteractiveLinkTextView!
    @IBOutlet weak var reviewArticleImageView: UIImageView!
    @IBOutlet weak var reviewArticleImageViewConstraintsHeight: NSLayoutConstraint!
    @IBOutlet weak var agreeButton: UIButton!
    @IBOutlet weak var deniedButton: UIButton!
    
    var loadingView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), type: .randomPick(), color: .cyan, padding: .none)
    var reloadBlock: (() -> ())?
    var reviewStatus: ReviewCellData?
    var id: Int?
    var aye: Int?
    var nay: Int?
    var review: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let reviewStatus = self.reviewStatus else { return }
        self.id = reviewStatus.id
        self.aye = reviewStatus.aye
        self.nay = reviewStatus.nay
        self.review = reviewStatus.review
        guard let id = self.id else { return }
        
        reviewArticleImageView.isHidden = true
        initToRadiusButton(agreeButton)
        initToRadiusButton(deniedButton)
        
        self.loadingView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.loadingView)
        NSLayoutConstraint.init(item: self.loadingView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint.init(item: self.loadingView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1.0, constant: 0.0).isActive = true
        
        // Request Success Start
        // 1. 設定 reviewArticleTitleLabel
        reviewArticleTitleLabel.text = String.tagConvert(from: id)
        // 2. loadReviewArticleImage(放上圖片) // 設定 ImageView 的 Image
        self.loadingView.startAnimating()
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let img = try UIImage(data: Data(contentsOf: URL(string: reviewStatus.image)!))
                DispatchQueue.main.async {
                    self.loadingView.stopAnimating()
                    self.loadReviewArticleImage(img)
                }
            } catch {
                //let img = UIImage(named: "img_flag1")
                DispatchQueue.main.async {
                    // TODO: Add failure image
                    //self?.loadArticleImage(img)
                    self.loadingView.stopAnimating()
                }
            }
        }
        // 3. 設定 TextView（你自己文章列表用的，先替換掉 Storyboard 的東西）
        // textview內容用：reviewStatus.content
        reviewArticleContentTextView.setAttributedTextWithHTMLStyle(source: reviewStatus.content)
        // 4. setVoteState(agree: 通過, denied: 否決, review: 使用者投票狀態)
        guard let aye = self.aye, let nay = self.nay, let review = self.review else { return }
        setVoteState(agree: aye, denied: nay, review: review)
        // Request Success End
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func initToRadiusButton(_ button: UIButton) {
        button.layer.cornerRadius = 10;
        button.clipsToBounds = true;
    }
    
    func loadReviewArticleImage(_ presentImage: UIImage?) {
        if let presentImage = presentImage {
            let ratio = presentImage.size.width / presentImage.size.height                      // 計算圖片寬高比
            let newHeight = reviewArticleImageView.frame.width / ratio
            reviewArticleImageViewConstraintsHeight.constant = newHeight                              // 計算 UIImageView 高度
            view.layoutIfNeeded()
            reviewArticleImageView.image = presentImage
            reviewArticleImageView.isHidden = false                                                   // 顯示圖片並解除隱藏
        }
    }
    
    func setVoteState(agree: Int, denied: Int, review: Int) {
        voteCountInButton(agree: agree, denied: denied)
        if (review != 0) {
            voteButtonDisable()
            if (review > 0) {
                deniedButton.backgroundColor = #colorLiteral(red: 0.8985503316, green: 0.3016347587, blue: 0.3388397694, alpha: 0.5) // #dc3545 0.5
            }
            else {
                agreeButton.backgroundColor = #colorLiteral(red: 0.1690405011, green: 0.6988298297, blue: 0.3400650322, alpha: 0.5) // #28a745 0.5
            }
        }
    }
    
    func voteCountInButton(agree: Int, denied: Int) {
        agreeButton.setTitle(String(agree), for: .disabled)
        deniedButton.setTitle(String(denied), for: .disabled)
    }
    
    func voteButtonDisable() {
        agreeButton.isEnabled = false
        deniedButton.isEnabled = false
    }
    
    @IBAction func agreeButtonPressed(_ sender: UIButton) {
        voteButtonDisable()
        // Agree Request Success Start
        deniedButton.backgroundColor = #colorLiteral(red: 0.8985503316, green: 0.3016347587, blue: 0.3388397694, alpha: 0.5) // #dc3545 0.5
        guard let id = self.id, let accessToken = KeyChainManager.shared.getToken() else { return }
        
        let ayeRequest = KBGetArticleVoteAye(accessToken: accessToken, id: id)
        
        KaobeiConnection.sendRequest(api: ayeRequest) {[weak self] (response) in
            switch response.result {
            case.success(let data):
                let aye = data.data.succeeded
                let nay = data.data.failed
                DispatchQueue.main.async {
                    self?.voteCountInButton(agree: aye, denied: nay)
                    self?.reviewStatus?.updateVote(aye: aye, nay: nay)
                    self?.reloadBlock?()
                }
                break
            case.failure(_):
                if response.response?.statusCode == 401 {
                    if let vc = self?.tabBarController as? KaobeiTabBarController {
                        vc.expiredTimeoutToLogout()
                    }
                }
                break
            }
        }
        // voteCountInButton(agree: 1, denied: -1) // 投票後回傳的結果就會是已經加上使用者投票的結果，直接寫入即可
        // Agree Request Success End
    }
    
    
    @IBAction func deniedButtonPressed(_ sender: UIButton) {
        voteButtonDisable()
        // Reject Request Success Start
        agreeButton.backgroundColor = #colorLiteral(red: 0.1690405011, green: 0.6988298297, blue: 0.3400650322, alpha: 0.5) // #28a745 0.5
        guard let id = self.id, let accessToken = KeyChainManager.shared.getToken() else { return }
        
        let nayRequest = KBGetArticleVoteNay(accessToken: accessToken, id: id)
        
        KaobeiConnection.sendRequest(api: nayRequest) {[weak self] (response) in
            switch response.result {
            case.success(let data):
                let aye = data.data.succeeded
                let nay = data.data.failed
                DispatchQueue.main.async {
                    self?.voteCountInButton(agree: aye, denied: nay)
                    self?.reviewStatus?.updateVote(aye: aye, nay: nay)
                    self?.reloadBlock?()
                }
                break
            case.failure(_):
                if response.response?.statusCode == 401 {
                    if let vc = self?.tabBarController as? KaobeiTabBarController {
                        vc.expiredTimeoutToLogout()
                    }
                }
                break
            }
        }
        // voteCountInButton(agree: 1, denied: -1) // 投票後回傳的結果就會是已經加上使用者投票的結果，直接寫入即可
        // Reject Request Success End
    }
}
