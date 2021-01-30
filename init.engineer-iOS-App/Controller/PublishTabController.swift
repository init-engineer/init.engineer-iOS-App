//
//  PublishTabController.swift
//  init.engineer-iOS-App
//
//  Created by horo on 6/6/20.
//  Copyright © 2020 Kantai Developer. All rights reserved.
//

import UIKit

class PublishTabController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var articleImg: UIImageView!
    @IBOutlet weak var articleText: UITextView!
    @IBOutlet weak var themePicker: UIPickerView!
    @IBOutlet weak var fontPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let accessToken = KeyChainManager.shared.getToken() {
            print(accessToken)
        }
        else {
            self.performSegue(withIdentifier: K.publishToLoginSegue, sender: self)
        }
    }

    @IBAction func imageUploadBtn(_ sender: Any) {
        
        let controller = UIImagePickerController()
        controller.sourceType = .photoLibrary
        self.present(controller, animated: true)
        controller.delegate = self
    }
    
}

extension PublishTabController {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        let imgData = NSData(data: image!.jpegData(compressionQuality: 1)!)
        let imageSize: Int = imgData.count
        print("actual size of image in KB: %f ", Double(imageSize) / 1000.0)
        articleImg.image = image
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        articleImg.image = nil
        picker.dismiss(animated: true, completion: nil)
    }
}
