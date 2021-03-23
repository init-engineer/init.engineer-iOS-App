//
//  ArticleViewController.swift
//  init.engineer-iOS-App
//
//  Created by horo on 6/7/20.
//  Copyright © 2020 Kantai Developer. All rights reserved.
//

import UIKit
import KaobeiAPI
import GoogleMobileAds
import NVActivityIndicatorView

class ArticleViewController: UIViewController {
    
    @IBOutlet weak var articleStackView: UIStackView!
    @IBOutlet weak var articleScrollView: UIScrollView!
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var articleImageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var articleContentTextView: UITextView!
    @IBOutlet weak var primaryFacebookLikeLabel: UILabel!
    @IBOutlet weak var primaryFacebookShareLabel: UILabel!
    @IBOutlet weak var secondaryFacebookLikeLabel: UILabel!
    @IBOutlet weak var secondaryFacebookShareLabel: UILabel!
    @IBOutlet weak var plurkLikeLabel: UILabel!
    @IBOutlet weak var plurkShareLabel: UILabel!
    @IBOutlet weak var twitterLikeLabel: UILabel!
    @IBOutlet weak var twitterShareLabel: UILabel!
    @IBOutlet weak var commentsTableView: UITableView!
    @IBOutlet weak var commentsTableViewHeight: NSLayoutConstraint!

    
    var loadingView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), type: .randomPick(), color: .cyan, padding: .none)
    var loadingImage = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), type: .randomPick(), color: .cyan, padding: .none)
    
    var commentsList = [Comment]()
    
    var articleID: Int?
    var commentCurrentPage = 1
    var reloadBlocker = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.articleScrollView.delegate = self
        self.loadingImage.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.loadingImage)
        NSLayoutConstraint.init(item: self.loadingImage, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint.init(item: self.loadingImage, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1.0, constant: 0.0).isActive = true
        
        guard let id = self.articleID else { return } //back to article list
        
        articleTitleLabel.text = String.tagConvert(from: id)
        
        let detailRequest = KBGetArticleDetail(id: id)
        self.loadingImage.startAnimating()
        KaobeiConnection.sendRequest(api: detailRequest) { [weak self] (response) in
            switch response.result {
                case .success(let data):
                    self?.articleContentTextView.text = data.data.content
                    DispatchQueue.global(qos: .userInitiated).async {
                        do {
                            let articleImage = try UIImage(data: Data(contentsOf: URL(string: data.data.image)!))
                            DispatchQueue.main.async {
                                self?.loadArticleImage(articleImage)
                                self?.loadingImage.stopAnimating()
                            }
                        } catch {
                            //let img = UIImage(named: "img_flag1")
                            DispatchQueue.main.async {
                                // TODO: Add failure image
                                //self?.loadArticleImage(img)
                                self?.loadingImage.stopAnimating()
                            }
                        }
                    }
                    break
                case .failure(_):
                    break
            }
        }
        
        let statsRequest = KBGetArticleStats(id: id)
        
        KaobeiConnection.sendRequest(api: statsRequest) { [weak self] (response) in
            switch response.result {
                case .success(let data):
                    for item in data.data {
                        if item.type == "twitter" {
                            self?.twitterLikeLabel.text = "♥︎ \(item.like)"
                            self?.twitterShareLabel.text = "↻ \(item.share)"
                        } else if item.type == "plurk" {
                            self?.plurkLikeLabel.text = "♥︎ \(item.like)"
                            self?.plurkShareLabel.text = "↻ \(item.share)"
                        } else if item.type == "facebook" {
                            if item.connections == "primary" {
                                self?.primaryFacebookLikeLabel.text = "♥︎ \(item.like)"
                                self?.primaryFacebookShareLabel.text = "↻ \(item.share)"
                            } else if item.connections == "secondary" {
                                self?.secondaryFacebookLikeLabel.text = "♥︎ \(item.like)"
                                self?.secondaryFacebookShareLabel.text = "↻ \(item.share)"
                            }
                        }
                    }
                   break
                case .failure(_):
                   break
            }
        }
        
        reloadBlocker = true
        let commentRequest = KBGetArticleComments(id: id)
        KaobeiConnection.sendRequest(api: commentRequest) { [weak self] (response) in
            self?.reloadBlocker = false
            switch response.result {
                case .success(let data):
                    if data.meta.pagination.count == 0 {
                        self?.reloadBlocker = true
                    }
                    for c in data.data {
                        let s = ArticleCommentCell()
                        s.renderComment(with: c)
                        self?.articleStackView.addArrangedSubview(s)
                    }
                    self?.commentCurrentPage += 1
                    break
                case .failure(_):
                    break
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func loadArticleImage(_ presentImage: UIImage?) {
        if let presentImage = presentImage {
            let ratio = presentImage.size.width / presentImage.size.height                      // 計算圖片寬高比
            let newHeight = articleImageView.frame.width / ratio
            articleImageViewHeight.constant = newHeight                              // 計算 UIImageView 高度
            view.layoutIfNeeded()
            articleImageView.image = presentImage
            articleImageView.isHidden = false                                                   // 顯示圖片並解除隱藏
        }
    }
    
    func loadMoreComment() {
        if reloadBlocker == true {
            return
        }
        print("LOADMORE")
        reloadBlocker = true
        guard let id = self.articleID else { return }
        articleStackView.addArrangedSubview(loadingView)
        loadingView.startAnimating()
        let commentRequest = KBGetArticleComments(id: id, page: self.commentCurrentPage)
        KaobeiConnection.sendRequest(api: commentRequest) { [weak self] (response) in
            self?.loadingView.stopAnimating()
            self?.articleStackView.removeArrangedSubview(self!.loadingView)
            switch response.result {
                case .success(let data):
                    for c in data.data {
                        let s = ArticleCommentCell()
                        s.renderComment(with: c)
                        self?.articleStackView.addArrangedSubview(s)
                    }
                    self?.commentCurrentPage += 1
                    if data.meta.pagination.count == 0 {
                        self?.reloadBlocker = true
                    } else {
                        self?.reloadBlocker = false
                    }
                    break
                case .failure(_):
                    self?.reloadBlocker = false
                    break
            }
        }
    }
    
}

extension ArticleViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height

        if (maximumOffset - currentOffset <= 100.0) && !reloadBlocker {
            self.loadMoreComment()
        }
    }
    
}
