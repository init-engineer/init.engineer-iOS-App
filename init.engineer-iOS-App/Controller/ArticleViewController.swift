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

    
    let loadingView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), type: .randomPick(), color: .cyan, padding: .none)
    var articleID: Int?
    var commentCurrentPage = 1
    var commentMaxPage: Int?
    var reloadBlocker = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.articleScrollView.delegate = self
        guard let id = self.articleID else { return } // back to article list
        
        articleTitleLabel.text = String.tagConvert(from: id)
        
        let detailRequest = KBGetArticleDetail(id: id)
        
        KaobeiConnection.sendRequest(api: detailRequest) { [weak self] (response) in
            switch response.result {
                case .success(let data):
                    self?.articleContentTextView.text = data.data.content
                    DispatchQueue.global(qos: .userInitiated).async {
                        do {
                            let articleImage = try UIImage(data: Data(contentsOf: URL(string: data.data.image)!))
                            DispatchQueue.main.async {
                                self?.loadArticleImage(articleImage)
                            }
                        } catch is Error {
                            
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
                    for c in data.data {
                        let s = ArticleCommentCell()
                        s.renderComment(with: c)
                        self?.articleStackView.addArrangedSubview(s)
                    }
                    self?.commentCurrentPage += 1
                    self?.commentMaxPage = data.meta.pagination.totalPages
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
        guard let maxPage = self.commentMaxPage else { return }
        if maxPage + 1 >= self.commentCurrentPage {
            articleStackView.addArrangedSubview(loadingView)
            loadingView.startAnimating()
            let commentRequest = KBGetArticleComments(id: id, page: self.commentCurrentPage)
            KaobeiConnection.sendRequest(api: commentRequest) { [weak self] (response) in
                self?.reloadBlocker = false
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
                        break
                    case .failure(_):
                        break
                }
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
