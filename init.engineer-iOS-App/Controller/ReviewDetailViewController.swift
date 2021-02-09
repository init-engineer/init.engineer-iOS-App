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

class ReviewDetailViewController: UIViewController {
    
    @IBOutlet weak var reviewArticleTitleLabel: UILabel!
    @IBOutlet weak var reviewArticleContentTextView: UITextView!
    @IBOutlet weak var reviewArticleImageView: UIImageView!
    @IBOutlet weak var reviewArticleImageViewConstraintsHeight: NSLayoutConstraint!
    @IBOutlet weak var agreeButton: UIButton!
    @IBOutlet weak var deniedButton: UIButton!
    
    var reloadBlock: (() -> ())?
    var reviewStatus: ArticleUnderReview?
    var id: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reviewArticleImageView.isHidden = true
        initToRadiusButton(agreeButton)
        initToRadiusButton(deniedButton)
        
        guard let reviewStatus = self.reviewStatus else { return }
        // Request Success Start
        // 1. 設定 reviewArticleTitleLabel
        reviewArticleTitleLabel.text = K.tagConvert(from: id!)
        // 2. loadReviewArticleImage(放上圖片) // 設定 ImageView 的 Image
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let img = try UIImage(data: Data(contentsOf: URL(string: reviewStatus.image)!))
                DispatchQueue.main.async {
                    self.loadReviewArticleImage(img)
                }
            } catch is Error {
                
            }
        }
        // 3. 設定 TextView（你自己文章列表用的，先替換掉 Storyboard 的東西）
        // textview內容用：reviewStatus.content
        reviewArticleContentTextView.text = reviewStatus.content
        // 4. setVoteState(agree: 通過, denied: 否決, review: 使用者投票狀態)
        setVoteState(agree: reviewStatus.succeeded, denied: reviewStatus.failed, review: reviewStatus.review)
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
                DispatchQueue.main.async {
                    self?.voteCountInButton(agree: data.data.succeeded, denied: data.data.failed)
                    self?.reloadBlock?()
                }
                break
            case.failure(_):
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
                DispatchQueue.main.async {
                    self?.voteCountInButton(agree: data.data.succeeded, denied: data.data.failed)
                    self?.reloadBlock?()
                }
                break
            case.failure(_):
                break
            }
        }
        // voteCountInButton(agree: 1, denied: -1) // 投票後回傳的結果就會是已經加上使用者投票的結果，直接寫入即可
        // Reject Request Success End
    }
}
