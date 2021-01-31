//
//  PublishTabController.swift
//  init.engineer-iOS-App
//
//  Created by horo on 6/6/20.
//  Copyright © 2020 Kantai Developer. All rights reserved.
//

import UIKit

class PublishTabController: UIViewController {
    @IBOutlet weak var publishScrollView: UIScrollView!
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var articleImageViewConstraintsHeight: NSLayoutConstraint!
    @IBOutlet weak var articleTextView: UITextView!
    @IBOutlet weak var ruleTextView: UITextView!
    @IBOutlet weak var themePickerView: UIPickerView!
    @IBOutlet weak var fontPickerView: UIPickerView!
    
    let picker1Options = ["Option 1","Option 2","Option 3","Option 4","Option 5"]
    let picker2Options = ["Item 1","Item 2","Item 3","Item 4","Item 5"]
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        if let accessToken = KeyChainManager.shared.getToken() {
            print(accessToken)
        }
        else {
            self.performSegue(withIdentifier: K.publishToLoginSegue, sender: self)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    
    private func radiusTextView(_ tv: UITextView) {
        tv.contentInset = UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4);
        tv.layer.cornerRadius = 10
        tv.layer.borderColor = UIColor.white.cgColor
        tv.layer.borderWidth = 0.5
        tv.clipsToBounds = true
    }
    
    private func initArticleTextView(_ tv: UITextView){
        tv.text = K.publishArticlePlaceholderText
        tv.textColor = K.publishArticlePlaceholderTextColor
        tv.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        articleTextView.resignFirstResponder()
    }

    @IBAction func imageUploadButtonPressed(_ sender: UIButton) {
        let controller = UIImagePickerController()
        controller.sourceType = .photoLibrary
        self.present(controller, animated: true)
        controller.delegate = self
    }
    
}

// MARK: - UIScrollViewDelegate

extension PublishTabController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        articleTextView.resignFirstResponder()
    }
}

// MARK: - UITextViewDelegate

extension PublishTabController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == K.publishArticlePlaceholderTextColor {
            textView.text = nil
            textView.textColor = UIColor.white
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
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
            return picker1Options.count
        } else {
            return picker2Options.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if pickerView.tag == 1 {
            return NSAttributedString(string: picker1Options[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.yellow])
        } else {
            return NSAttributedString(string: picker2Options[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.yellow])
        }
    }
    
}

// MARK: - UIImagePickerControllerDelegate

extension PublishTabController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            let imgData = NSData(data: image.jpegData(compressionQuality: 1)!)
            let imageSize: Int = imgData.count
            print("actual size of image in MB: %f ", Double(imageSize) / 1024.0 / 1024.0)
            let ratio = image.size.width / image.size.height
            let newHeight = articleImageView.frame.width / ratio
            articleImageViewConstraintsHeight.constant = newHeight
            view.layoutIfNeeded()
            articleImageView.image = image
            articleImageView.isHidden = false
        }
        else {
            let controller = UIAlertController(title: "取得圖片失敗", message: "嗯？有點奇怪，怎麼取得失敗？", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Peko~", style: .default, handler: nil)
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        articleImageView.image = nil
        articleImageView.isHidden = true
        articleImageViewConstraintsHeight.constant = 0.0
        picker.dismiss(animated: true, completion: nil)
    }
}
