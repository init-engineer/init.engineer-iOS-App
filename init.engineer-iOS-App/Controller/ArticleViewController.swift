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

class ArticleViewController: UIViewController {
    @IBOutlet weak var articleImg: UIImageView!
    @IBOutlet weak var articleText: UITextView!
    @IBOutlet weak var mainFBLikeLabel: UILabel!
    @IBOutlet weak var alterFBLikeLabel: UILabel!
    @IBOutlet weak var plurkLikeLabel: UILabel!
    @IBOutlet weak var twitterLikeLabel: UILabel!
    @IBOutlet weak var mainFBShareLabel: UILabel!
    @IBOutlet weak var alterFBShareLabel: UILabel!
    @IBOutlet weak var plurkShareLabel: UILabel!
    @IBOutlet weak var twitterShareLabel: UILabel!
    @IBOutlet weak var commentListTable: UITableView!
    
    var commentList = [Comment]()
    
    var articleID: Int?
    var count = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.commentListTable.delegate = self
        self.commentListTable.dataSource = self
        self.commentListTable.allowsSelection = false
        self.articleText.isEditable = false
        self.articleText.isSelectable = false
        
        // self.articleImg.addGestureRecognizer()
        guard let id = self.articleID else { return } //back to article list
        
        let detailRequest = KBGetArticleDetail(id: id)
        
        KaobeiConnection.sendRequest(api: detailRequest) { [weak self] (response) in
            switch response.result {
                case .success(let data):
                    self?.articleText.text = data.data.content
                    do {
                        try self?.articleImg.image = UIImage(data: Data(contentsOf: URL(string: data.data.image)!))
                    } catch is Error {
                        
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
                            self?.twitterLikeLabel.text = "♥︎\(item.like)"
                            self?.twitterShareLabel.text = "⎋\(item.share)"
                        } else if item.type == "plurk" {
                            self?.plurkLikeLabel.text = "♥︎\(item.like)"
                            self?.plurkShareLabel.text = "⎋\(item.share)"
                        } else if item.type == "facebook" {
                            if item.connections == "primary" {
                                self?.mainFBLikeLabel.text = "♥︎\(item.like)"
                                self?.mainFBShareLabel.text = "⎋\(item.share)"
                            } else if item.connections == "secondary" {
                                self?.alterFBLikeLabel.text = "♥︎\(item.like)"
                                self?.alterFBShareLabel.text = "⎋\(item.share)"
                            }
                        }
                    }
                   break
                case .failure(_):
                   break
            }
        }
        
        let commentRequest = KBGetArticleComments(id: id)
        
        KaobeiConnection.sendRequest(api: commentRequest) { [weak self] (response) in
            switch response.result {
                case .success(let data):
                    self?.commentList.append(contentsOf: data.data)
                    self?.count += 1
                    self?.commentListTable.reloadData()
                    break
                case .failure(_):
                    break
            }
        }
        
    }
    
}

extension ArticleViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.commentList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.commentListTable.dequeueReusableCell(withIdentifier: "comment") as! UITableViewCell
        cell.textLabel?.text = self.commentList[indexPath.row].content
        cell.textLabel?.textColor = .white
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let h: CGFloat = CGFloat((self.commentList[indexPath.row].content.count / 10)) * 20.0
        return h
    }
}
