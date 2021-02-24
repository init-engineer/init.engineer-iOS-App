//
//  PreviewArticleController.swift
//  init.engineer-iOS-App
//
//  Created by 楊承昊 on 2021/2/25.
//  Copyright © 2021 Kantai Developer. All rights reserved.
//

import UIKit
import KaobeiAPI

class PreviewArticleController: UIViewController {
    
    var imageExtension = "jpg"
    
    override func viewDidLoad() {
        //
    }
    
//    func publishCheckSuccess() {        // 檢查正確則確認是否發表文章
//        let controller = UIAlertController(title: "您確定要發表文章嗎？", message: "如果您按下射射射，那文章就真的會射出去了。", preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "射射射", style: .default, handler: sendArticle)
//        let cancelAction = UIAlertAction(title: "不要！", style: .cancel)
//        controller.addAction(okAction)
//        controller.addAction(cancelAction)
//        present(controller, animated: true, completion: nil)
//    }
//    
//    func publishSendSuccess() {        // 文章發送成功
//        let controller = UIAlertController(title: "射射射！", message: "文章射出去惹，自動前往審核文章頁面。", preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "Peko~", style: .default)
//        controller.addAction(okAction)
//        present(controller, animated: true, completion: nil)
//    }
//    
//    private func resetPublishArticleForm() {    // 重置發表文章表單所有內容
//        articleTextView.text = K.publishArticlePlaceholderText
//        articleTextView.textColor = K.publishArticlePlaceholderTextColor
//        articleImageView.image = nil
//        articleImageView.isHidden = true
//        toBeContinuedDraw.setOn(false, animated: true)
//        agreePublishRule.setOn(false, animated: true)
//    }
//    
//    private func sendArticle(_ :UIAlertAction) {    // 發送文章實作
//        guard let accessToken = KeyChainManager.shared.getToken() else {
//            return
//        }
//        let article = articleTextView.text ?? ""
////        let font: String =  FontManager.shared.getFontValue(fontOptions[fontPickerView.selectedRow(inComponent: 0)])
////        let theme: String = ThemeManager.shared.getThemeValue(themeOptions[themePickerView.selectedRow(inComponent: 0)])
//        let font: String = "2"
//        let theme: String = "2"
//        let image: Data? = articleImageView.image?.jpegData(compressionQuality: 0.5)
//        let toBeContinued = toBeContinuedDraw.isOn
//        
//        let request = KBPostUserPublishing(accessToken: accessToken, article: article, toBeContinued: toBeContinued, font: font, theme: theme, image: image)
//        
//        if let _ = request.imageData {
//            KaobeiConnection.uploadRequest(api: request, with: self.imageExtension) { [weak self] response in
//                switch response.result {
//                case .success(_):
//                    /*
//                     如果 發送成功 則
//                     */
//                    self?.publishSendSuccess()        // 顯示文章發送成功
//                    self?.resetPublishArticleForm()   // 重置發表文章表單所有內容
//                    self?.tabBarController?.selectedIndex = 2    // 跳轉到審核文章
//                    if let reviewNavi = self?.tabBarController?.selectedViewController as? UINavigationController {
//                        reviewNavi.popToRootViewController(animated: true)
//                        if let reviewListVC = reviewNavi.topViewController as? ReviewTabController {
//                            reviewListVC.reloadReviews()
//                        }
//                    }
//                    break
//                case .failure(_):
//                    if let failTitle = response.response?.statusCode {
//                        DispatchQueue.main.async {
//                            self?.publishCheckFailed(failTitle: String(failTitle), failedMessage: "上面的數字可以記下來給版主，但應該沒什麼用，重新發一篇如何？")
//                        }
//                    }
//                    break
//                }
//            }
//        } else {
//            KaobeiConnection.sendRequest(api: request) { [weak self] response in
//                switch response.result {
//                case .success(_):
//                    /*
//                     如果 發送成功 則
//                     */
//                    self?.publishSendSuccess()        // 顯示文章發送成功
//                    self?.resetPublishArticleForm()   // 重置發表文章表單所有內容
//                    self?.tabBarController?.selectedIndex = 2    // 跳轉到審核文章
//                    break
//                case .failure(_):
//                    if let failTitle = response.response?.statusCode {
//                        DispatchQueue.main.async {
//                            self?.publishCheckFailed(failTitle: String(failTitle), failedMessage: "上面的數字可以記下來給版主，但應該沒什麼用，重新發一篇如何？")
//                        }
//                    }
//                    break
//                }
//            }
//        }
//    }
}
