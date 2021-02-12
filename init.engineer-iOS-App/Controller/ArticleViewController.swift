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
    
    var commentsList = [Comment]()
    
    var articleID: Int?
    var commentCurrentPage = 1
    var commentMaxPage: Int?
    var reloadBlocker = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.articleScrollView.delegate = self
        self.commentsTableView.delegate = self
        self.commentsTableView.dataSource = self
        self.commentsTableView.allowsSelection = false
        self.commentsTableView.backgroundColor = .clear
        commentsTableView.register(UINib(nibName: K.articleCommentTableViewCell, bundle: nil), forCellReuseIdentifier: K.articleCommentTableViewCellIdentifier)
        guard let id = self.articleID else { return } //back to article list
        
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
                    self?.commentsList.append(contentsOf: data.data)
                    self?.commentCurrentPage += 1
                    self?.commentMaxPage = data.meta.pagination.totalPages
                    self?.commentsTableView.reloadData()
                    break
                case .failure(_):
                    break
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.commentsTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.commentsTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.commentsTableView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            if object is UITableView {
                if let newValue = change?[.newKey] {
                    let newSize = newValue as! CGSize
                    self.commentsTableViewHeight.constant = newSize.height
                }
            }
        }
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
            loadingView.startAnimating()
            let commentRequest = KBGetArticleComments(id: id, page: self.commentCurrentPage)
            KaobeiConnection.sendRequest(api: commentRequest) { [weak self] (response) in
                self?.reloadBlocker = false
                self?.loadingView.stopAnimating()
                switch response.result {
                    case .success(let data):
                        self?.commentsList.append(contentsOf: data.data)
                        self?.commentCurrentPage += 1
                        self?.commentsTableView.reloadData()
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

extension ArticleViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.commentsList.count
        } else if section == 1 {
            return 1
        } else {
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.articleCommentTableViewCellIdentifier, for: indexPath) as! ArticleCommentTableViewCell
            cell.commentUserAvaratImageView.image = UIImage(named: "no_avatar")
            cell.commentUserContentLabel.text = commentsList[indexPath.row].content
            cell.commentUserNameLabel.text = commentsList[indexPath.row].name
            cell.commentCreateTimeLabel.text = commentsList[indexPath.row].created
            if commentsList[indexPath.row].media.type == "plurk" {
                cell.commentBubble.backgroundColor = .systemRed
                cell.commentPlatformLabel.text = "Plurk"
            }
            else if commentsList[indexPath.row].media.type == "twitter" {
                cell.commentBubble.backgroundColor = .systemTeal
                cell.commentPlatformLabel.text = "Twitter"
            }
            else if commentsList[indexPath.row].media.type == "facebook" {
                cell.commentBubble.backgroundColor = .systemBlue
                if commentsList[indexPath.row].media.connections == "primary" {
                    cell.commentPlatformLabel.text = "Facebook 主站"
                }
                else if commentsList[indexPath.row].media.connections == "secondary" {
                    cell.commentPlatformLabel.text = "Facebook 次站"
                }
            }
            
            if commentsList[indexPath.row].avatar != "/img/frontend/user/nopic_192.gif" {
                DispatchQueue.main.async {
                    do {
                        let commentUserAvatarImage = try UIImage(data: Data(contentsOf: URL(string: self.commentsList[indexPath.row].avatar)!))
                        DispatchQueue.main.async {
                            cell.commentUserAvaratImageView.image = commentUserAvatarImage
                        }
                    } catch is Error {
                        
                    }
                }
            }
            return cell
        } else {
            let cell = UITableViewCell()
            cell.backgroundColor = .clear
            cell.addSubview(loadingView)
            cell.addConstraint(NSLayoutConstraint(item: cell, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 70))
            loadingView.translatesAutoresizingMaskIntoConstraints = false
            let horizontalConstraint = NSLayoutConstraint(item: loadingView, attribute: .centerX, relatedBy: .equal, toItem: cell, attribute: .centerX, multiplier: 1.0, constant: 0)
            let verticalConstraint = NSLayoutConstraint(item: loadingView, attribute: .centerY, relatedBy: .equal, toItem: cell, attribute: .centerY, multiplier: 1.0, constant: 0)
            cell.addConstraints([horizontalConstraint, verticalConstraint])
            return cell
        }
    }
    
}
