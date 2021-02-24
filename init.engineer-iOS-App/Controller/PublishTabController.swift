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
    @IBOutlet weak var toBeContinuedDraw: UISwitch!                             // To Be Continued 繪製開關
    @IBOutlet weak var ruleTextView: UITextView!                                // 板規文字
    @IBOutlet weak var themePickerView: UIPickerView!                           // 主題選擇器
    @IBOutlet weak var fontPickerView: UIPickerView!                            // 字體選擇器
    @IBOutlet weak var agreePublishRule: UISwitch!                              // 同意板規開關
    
    let fontOptions = FontManager.shared.fontExistArray
    let themeOptions = ThemeManager.shared.themeExistArray
    var imageExtension = "jpg"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        articleImageView.isHidden = true
        publishScrollView.delegate = self
        themePickerView.dataSource = self
        themePickerView.delegate = self
        fontPickerView.dataSource = self
        fontPickerView.delegate = self
        radiusTextView(ruleTextView)
        radiusTextView(articleTextView)
        initArticleTextView(articleTextView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "發表文章", style: .done, target: self, action: #selector(publishButtonPressed))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let accessToken = KeyChainManager.shared.getToken() {
            print(accessToken)
        }
        else {
            self.performSegue(withIdentifier: K.publishToLoginSegue, sender: self)
        }
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
    
    func publishCheckFailed(failTitle: String, failedMessage: String) { // 顯示檢查錯誤訊息
        let controller = UIAlertController(title: failTitle, message: failedMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Peko~", style: .default, handler: nil)
        controller.addAction(okAction)
        present(controller, animated: true, completion: nil)
    }
    
    func publishCheckSuccess() {        // 檢查正確則確認是否發表文章
        let controller = UIAlertController(title: "您確定要發表文章嗎？", message: "如果您按下射射射，那文章就真的會射出去了。", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "射射射", style: .default, handler: sendArticle)
        let cancelAction = UIAlertAction(title: "不要！", style: .cancel)
        controller.addAction(okAction)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
    }
    
    func publishSendSuccess() {        // 文章發送成功
        let controller = UIAlertController(title: "射射射！", message: "文章射出去惹，自動前往審核文章頁面。", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Peko~", style: .default)
        controller.addAction(okAction)
        present(controller, animated: true, completion: nil)
    }
    
    private func resetPublishArticleForm() {    // 重置發表文章表單所有內容
        articleTextView.text = K.publishArticlePlaceholderText
        articleTextView.textColor = K.publishArticlePlaceholderTextColor
        themePickerView.selectRow(0, inComponent: 0, animated: true)
        fontPickerView.selectRow(0, inComponent: 0, animated: true)
        articleImageView.image = nil
        articleImageView.isHidden = true
        toBeContinuedDraw.setOn(false, animated: true)
        agreePublishRule.setOn(false, animated: true)
    }
    
    private func sendArticle(_ :UIAlertAction) {    // 發送文章實作
        guard let accessToken = KeyChainManager.shared.getToken() else {
            return
        }
        let article = articleTextView.text ?? ""
        let font: String =  FontManager.shared.getFontValue(fontOptions[fontPickerView.selectedRow(inComponent: 0)])
        let theme: String = ThemeManager.shared.getThemeValue(themeOptions[themePickerView.selectedRow(inComponent: 0)])
        let image: Data? = articleImageView.image?.jpegData(compressionQuality: 0.5)
        let toBeContinued = toBeContinuedDraw.isOn
        
        let request = KBPostUserPublishing(accessToken: accessToken, article: article, toBeContinued: toBeContinued, font: font, theme: theme, image: image)
        
        if let _ = request.imageData {
            KaobeiConnection.uploadRequest(api: request, with: self.imageExtension) { [weak self] response in
                switch response.result {
                case .success(_):
                    /*
                     如果 發送成功 則
                     */
                    self?.publishSendSuccess()        // 顯示文章發送成功
                    self?.resetPublishArticleForm()   // 重置發表文章表單所有內容
                    self?.tabBarController?.selectedIndex = 2    // 跳轉到審核文章
                    if let reviewNavi = self?.tabBarController?.selectedViewController as? UINavigationController {
                        reviewNavi.popToRootViewController(animated: true)
                        if let reviewListVC = reviewNavi.topViewController as? ReviewTabController {
                            reviewListVC.reloadReviews()
                        }
                    }
                    break
                case .failure(_):
                    if let failTitle = response.response?.statusCode {
                        DispatchQueue.main.async {
                            self?.publishCheckFailed(failTitle: String(failTitle), failedMessage: "上面的數字可以記下來給版主，但應該沒什麼用，重新發一篇如何？")
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
                    self?.resetPublishArticleForm()   // 重置發表文章表單所有內容
                    self?.tabBarController?.selectedIndex = 2    // 跳轉到審核文章
                    break
                case .failure(_):
                    if let failTitle = response.response?.statusCode {
                        DispatchQueue.main.async {
                            self?.publishCheckFailed(failTitle: String(failTitle), failedMessage: "上面的數字可以記下來給版主，但應該沒什麼用，重新發一篇如何？")
                        }
                    }
                    break
                }
            }
        }
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
            publishCheckSuccess()
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

// MARK: - UIPickerViewDataSource, UIPickerViewDelegate

extension PublishTabController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return fontOptions.count
        } else {
            return themeOptions.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {   // 可以想說用主題顏色，但我懶得做，全都先用白色再說
        if pickerView.tag == 1 {
            return NSAttributedString(string: fontOptions[row])
        } else {
            return NSAttributedString(string: themeOptions[row])
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
