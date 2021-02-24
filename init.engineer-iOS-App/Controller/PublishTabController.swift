//
//  PublishTabController.swift
//  init.engineer-iOS-App
//
//  Created by horo on 6/6/20.
//  Copyright © 2020 Kantai Developer. All rights reserved.
//

import UIKit
import KaobeiAPI

class PublishTabController: UIViewController {
    @IBOutlet weak var publishScrollView: UIScrollView!                         // 捲動畫面
    @IBOutlet weak var articleImageView: UIImageView!                           // 使用者上傳的圖片預覽
    @IBOutlet weak var articleImageViewConstraintsHeight: NSLayoutConstraint!   // 圖片預覽的高度
    @IBOutlet weak var articleTextView: UITextView!                             // 使用者文章內容
    @IBOutlet weak var themeChooseButton: UIButton!
    @IBOutlet weak var fontChooseButton: UIButton!
    @IBOutlet weak var toBeContinuedDraw: UISwitch!                             // To Be Continued 繪製開關
    @IBOutlet weak var ruleTextView: UITextView!                                // 板規文字
    @IBOutlet weak var agreePublishRule: UISwitch!                              // 同意板規開關
    
    let themeOptions = ThemeManager.shared.themeExistArray
    let fontOptions = FontManager.shared.fontExistArray
    var imageExtension = "jpg"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        articleImageView.isHidden = true
        publishScrollView.delegate = self
        radiusTextView(ruleTextView)
        radiusTextView(articleTextView)
        initArticleTextView(articleTextView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "發表文章", style: .done, target: self, action: #selector(publishButtonPressed))
    }
    
    private func radiusTextView(_ tv: UITextView) {     // 將 TextView 變得圓角
        tv.contentInset = UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4);
        tv.layer.cornerRadius = 10
        tv.layer.borderColor = UIColor.white.cgColor
        tv.layer.borderWidth = 0.5
        tv.clipsToBounds = true
    }
    
    private func initArticleTextView(_ tv: UITextView){ // 文章內容初始化 Placeholder
        tv.text = K.publishArticlePlaceholderText
        tv.textColor = K.publishArticlePlaceholderTextColor
        tv.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)      // 點擊其他地方把鍵盤退出
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {     // 鍵盤退出動作
        articleTextView.resignFirstResponder()
    }

    @IBAction func imageUploadButtonPressed(_ sender: UIButton) {   // 上傳圖片按鈕
        let controller = UIImagePickerController()
        controller.sourceType = .photoLibrary
        self.present(controller, animated: true)
        controller.delegate = self
    }
    
    @IBAction func themeChooseButtonPressed(_ sender: UIButton) {
        let controller = UIAlertController(title: "", message: "選擇主題", preferredStyle: .actionSheet)
        for theme in themeOptions {
            let action = UIAlertAction(title: theme, style: .default) { (action) in
                self.themeChooseButton.setTitle(action.title, for: .normal)
            }
            controller.addAction(action)
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func fontChooseButtonPressed(_ sender: UIButton) {
        let controller = UIAlertController(title: "", message: "選擇字型", preferredStyle: .actionSheet)
        for font in fontOptions {
            let action = UIAlertAction(title: font, style: .default) { (action) in
                self.fontChooseButton.setTitle(action.title, for: .normal)
            }
            controller.addAction(action)
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
    }
    
    func publishCheckFailed(failTitle: String, failedMessage: String) { // 顯示檢查錯誤訊息
        let controller = UIAlertController(title: failTitle, message: failedMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Peko~", style: .default, handler: nil)
        controller.addAction(okAction)
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func publishButtonPressed(_ sender: UIButton) {   // 發送文章按鈕動作
        if !agreePublishRule.isOn {
            publishCheckFailed(failTitle: "呃......", failedMessage: "您必須同意以上版規。")
        }
        else if articleTextView.text == K.publishArticlePlaceholderText && articleTextView.textColor == K.publishArticlePlaceholderTextColor {
            publishCheckFailed(failTitle: "您根本的內容不符合規範啊！", failedMessage: "欠閃退逆？你根本沒打字 = =")
        }
        else if articleTextView.text.count < 5 {
            publishCheckFailed(failTitle: "您根本的內容不符合規範啊！", failedMessage: "至少 5 個字以上")
        }
        else {
            performSegue(withIdentifier: "publishToPreview", sender: nil)
        }
    }
}

// MARK: - UIScrollViewDelegate

extension PublishTabController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {  // ScrollView 捲動時將鍵盤關閉
        articleTextView.resignFirstResponder()
    }
}

// MARK: - UITextViewDelegate

extension PublishTabController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == K.publishArticlePlaceholderTextColor { // 開始編輯時將自定 Placeholder 拿掉
            textView.text = nil
            textView.textColor = UIColor.white
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {                                      // 結束編輯時，如果字串為空則將自定 Placeholder 放上
            textView.text = K.publishArticlePlaceholderText
            textView.textColor = K.publishArticlePlaceholderTextColor
        }
    }
}

// MARK: - UIImagePickerControllerDelegate

extension PublishTabController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {    // 選擇圖片
        if let image = info[.originalImage] as? UIImage {
            if let imgURL = info[.imageURL] as? URL{
                self.imageExtension = imgURL.pathExtension
            }
            if let presentImage = image.compressTo(2) {
                let ratio = presentImage.size.width / presentImage.size.height                      // 計算圖片寬高比
                let newHeight = articleImageView.frame.width / ratio
                articleImageViewConstraintsHeight.constant = newHeight                              // 計算 UIImageView 高度
                view.layoutIfNeeded()
                articleImageView.image = presentImage
                articleImageView.isHidden = false                                                   // 顯示圖片並解除隱藏
            }
            else {
                let controller = UIAlertController(title: "取得圖片壓縮失敗", message: "選取的照片過大無法壓縮", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Peko~", style: .default, handler: nil)
                controller.addAction(okAction)
                present(controller, animated: true, completion: nil)
            }
            
        }
        else {
            let controller = UIAlertController(title: "取得圖片失敗", message: "嗯？有點奇怪，怎麼取得失敗？", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Peko~", style: .default, handler: nil)
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {                    // 取消視為不選擇圖片
        articleImageView.image = nil
        articleImageView.isHidden = true
        articleImageViewConstraintsHeight.constant = 0.0
        picker.dismiss(animated: true, completion: nil)
    }
}


// MARK: - UIImage Binary Compress
// Source Code Link: https://stackoverflow.com/a/50582203
extension UIImage {
    func compressTo(_ expectedSizeInMb:Int) -> UIImage? {
        let sizeInBytes = expectedSizeInMb * 1024 * 1024
        var needCompress:Bool = true
        var imgData:Data?
        var compressingValue:CGFloat = 1.0
        while (needCompress && compressingValue > 0.0) {
            if let data:Data = self.jpegData(compressionQuality: compressingValue) {
                if data.count < sizeInBytes {
                    needCompress = false
                    imgData = data
                } else {
                    compressingValue -= 0.1
                }
            }
    }

    if let data = imgData {
        if (data.count < sizeInBytes) {
            return UIImage(data: data)
        }
    }
        return nil
    }
}
