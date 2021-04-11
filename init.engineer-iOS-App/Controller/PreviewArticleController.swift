//
//  PreviewArticleController.swift
//  init.engineer-iOS-App
//
//  Created by 楊承昊 on 2021/2/25.
//  Copyright © 2021 Kantai Developer. All rights reserved.
//

import UIKit


class PreviewArticleController: UIViewController {
    
    @IBOutlet weak var windowsScreenHeader: UIImageView!
    @IBOutlet weak var windowsScreenFooter: UIImageView!
    @IBOutlet weak var windowsScreenHeaderHeight: NSLayoutConstraint!
    @IBOutlet weak var windowsScreenFooterHeight: NSLayoutConstraint!
    @IBOutlet weak var articleHeaderTextView: UITextView!
    @IBOutlet weak var articleTextView: UITextView!
    @IBOutlet weak var toBeContinuedStackView: UIStackView!
    @IBOutlet weak var toBeContinuedImageView: UIImageView!
    @IBOutlet weak var toBeContinuedBlank: UITextView!
    @IBOutlet weak var toBeContinuedImageHeight: NSLayoutConstraint!
    @IBOutlet weak var articleFooterStackView: UIStackView!
    @IBOutlet weak var articleFooterLeftTextView: UITextView!
    @IBOutlet weak var articleFooterRightTextView: UITextView!
    var articleText: String?
    var themeChooseName: String?
    var fontChooseName: String?
    var articleImage: UIImage?
    var toBeContinue: Bool?
    var imageExtension = "jpg"
    
    override func viewDidLoad() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "發表文章", style: .done, target: self, action: #selector(publishCheckSuccess))
        
        articleTextView.text = articleText
        guard let themeChooseName = themeChooseName else { return }
        if let theme = ThemeManager.shared.getThemeData(themeChooseName) {
            articleTextView.backgroundColor = UIColor.init(hex: theme.background_color)
            articleTextView.textColor = UIColor.init(hex: theme.text_color)
            articleHeaderTextView.backgroundColor = UIColor.init(hex: theme.background_color)
            toBeContinuedImageView.backgroundColor = UIColor.init(hex: theme.background_color)
            toBeContinuedBlank.backgroundColor = UIColor.init(hex: theme.background_color)
            articleFooterLeftTextView.backgroundColor = UIColor.init(hex: theme.background_color)
            articleFooterLeftTextView.textColor = UIColor.init(hex: theme.text_color)
            articleFooterRightTextView.backgroundColor = UIColor.init(hex: theme.background_color)
            articleFooterRightTextView.textColor = UIColor.init(hex: theme.text_color)
            if theme.name == "Windows 最棒的畫面 測試人員組件" {
                articleHeaderTextView.isHidden = true
                articleFooterStackView.isHidden = true
                displayWindowsScreen(isGreen: true)
            } else if theme.name == "Windows 最棒的畫面" {
                articleHeaderTextView.isHidden = true
                articleFooterStackView.isHidden = true
                displayWindowsScreen(isGreen: false)
            }
        }
        
        guard let toBeContinued = toBeContinue else { return }
        if toBeContinued {
            displayToBeContinued()
        } else {
            toBeContinuedStackView.isHidden = true
        }
    }
    
    @objc func publishCheckSuccess() {
        let controller = UIAlertController(title: "您確定要發表文章嗎？", message: "發表文章視為同意版規。\n如果您按下射射射，那文章就真的會射出去了。", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "射射射！", style: .default, handler: sendArticle)
        let ruleAction = UIAlertAction(title: "查看版規", style: .destructive, handler: displayRule)
        let cancelAction = UIAlertAction(title: "不要！", style: .cancel)
        controller.addAction(okAction)
        controller.addAction(ruleAction)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
    }
    
    func displayRule(_: UIAlertAction) {
        performSegue(withIdentifier: K.preivewToRuleSegue, sender: nil);
    }
    
    func publishSendSuccess() {        // 文章發送成功
        let controller = UIAlertController(title: "射射射！", message: "文章射出去惹，自動前往審核文章頁面。", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Peko~", style: .default)
        controller.addAction(okAction)
        present(controller, animated: true, completion: nil)
    }
    
    func publishSendFailed(failTitle: String, failedMessage: String) { // 文章發送失敗錯誤訊息
        let controller = UIAlertController(title: failTitle, message: failedMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Peko~", style: .default, handler: nil)
        controller.addAction(okAction)
        present(controller, animated: true, completion: nil)
    }
    
//    private func resetPublishArticleForm() {    // 重置發表文章表單所有內容
//        articleTextView.text = K.publishArticlePlaceholderText
//        articleTextView.textColor = K.publishArticlePlaceholderTextColor
//        articleImageView.image = nil
//        articleImageView.isHidden = true
//        toBeContinuedDraw.setOn(false, animated: true)
//        agreePublishRule.setOn(false, animated: true)
//    }
    
    func displayToBeContinued() {
        toBeContinuedStackView.isHidden = false
        if let image = toBeContinuedImageView.image {
            let ratio = image.size.width / image.size.height
            let newHeight = toBeContinuedImageView.frame.width / ratio
            toBeContinuedImageHeight.constant = newHeight
            view.layoutIfNeeded()
            toBeContinuedImageView.isHidden = false
        }
    }
    
    func displayWindowsScreen(isGreen: Bool = false) {
        if isGreen {
            windowsScreenHeader.image = UIImage(named: "green_screen_header")
            windowsScreenFooter.image = UIImage(named: "green_screen_footer")
        }
        if let image = windowsScreenHeader.image {
            let ratio = image.size.width / image.size.height
            let newHeight = windowsScreenHeader.frame.width / ratio
            windowsScreenHeaderHeight.constant = newHeight
            view.layoutIfNeeded()
            windowsScreenHeader.isHidden = false
        }
        if let image = windowsScreenFooter.image {
            let ratio = image.size.width / image.size.height
            let newHeight = windowsScreenFooter.frame.width / ratio
            windowsScreenFooterHeight.constant = newHeight
            view.layoutIfNeeded()
            windowsScreenFooter.isHidden = false
        }
    }
    
    private func sendArticle(_ :UIAlertAction) {    // 發送文章實作
        guard let accessToken = KeyChainManager.shared.getToken() else {
            return
        }
        guard let fontName = fontChooseName else { return }
        guard let themeName = themeChooseName else { return }
        guard let toBeContinued = toBeContinue else { return }
        let article = articleText ?? ""
        let font: String = FontManager.shared.getFontValue(fontName)
        let theme: String = ThemeManager.shared.getThemeValue(themeName)
        let image: Data? = articleImage?.jpegData(compressionQuality: 0.5)
        
        let request = KBPostUserPublishing(accessToken: accessToken, article: article, toBeContinued: toBeContinued, font: font, theme: theme, image: image)
        
        if let _ = request.imageData {
            KaobeiConnection.uploadRequest(api: request, with: self.imageExtension) { [weak self] response in
                switch response.result {
                case .success(_):
                    /*
                     如果 發送成功 則
                     */
                    self?.publishSendSuccess()        // 顯示文章發送成功
//                    self?.resetPublishArticleForm()   // 重置發表文章表單所有內容
                    self?.tabBarController?.selectedIndex = 2    // 跳轉到審核文章
                    if let reviewNavi = self?.tabBarController?.selectedViewController as? UINavigationController {
                        reviewNavi.popToRootViewController(animated: true)
                        if let reviewListVC = reviewNavi.topViewController as? ReviewTabController {
                            reviewListVC.reloadReviews()
                        }
                    }
                    break
                case .failure(_):
                    if response.response?.statusCode == 401 {
                        if let vc = self?.tabBarController as? KaobeiTabBarController {
                            vc.expiredTimeoutToLogout()
                        }
                    }
                    if let failTitle = response.response?.statusCode {
                        DispatchQueue.main.async {
                            self?.publishSendFailed(failTitle: String(failTitle), failedMessage: "上面的數字可以記下來給版主，但應該沒什麼用，重新發一篇如何？")
                        }
                    }
                    break
                }
            }
        } else {
            KaobeiConnection.sendRequest(api: request) { [weak self] response in
                switch response.result {
                case .success(_):
                    /*
                     如果 發送成功 則
                     */
                    self?.publishSendSuccess()        // 顯示文章發送成功
//                    self?.resetPublishArticleForm()   // 重置發表文章表單所有內容
                    self?.tabBarController?.selectedIndex = 2    // 跳轉到審核文章
                    break
                case .failure(_):
                    if response.response?.statusCode == 401 {
                        if let vc = self?.tabBarController as? KaobeiTabBarController {
                            vc.expiredTimeoutToLogout()
                        }
                    }
                    if let failTitle = response.response?.statusCode {
                        DispatchQueue.main.async {
                            self?.publishSendFailed(failTitle: String(failTitle), failedMessage: "上面的數字可以記下來給版主，但應該沒什麼用，重新發一篇如何？")
                        }
                    }
                    break
                }
            }
        }
    }
}
