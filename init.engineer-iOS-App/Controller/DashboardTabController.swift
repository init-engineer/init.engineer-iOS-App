//
//  DashboardTabController.swift
//  init.engineer-iOS-App
//
//  Created by horo on 6/6/20.
//  Copyright © 2020 Kantai Developer. All rights reserved.
//

import UIKit
import GoogleMobileAds

class DashboardTabController: UIViewController, GADBannerViewDelegate {
    @IBOutlet weak var userImg: UIImageView!
    var bannerView: GADBannerView!
    var logoutBtn = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let accessToken = KeyChainManager.shared.getToken() {
            print(accessToken)
        }
        else {
            self.performSegue(withIdentifier: K.dashboardToLoginSegue, sender: self)
        }
    }

    func setupUI() {
        // In this case, we instantiate the banner with desired ad size.
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.adUnitID = K.getInfoPlistByKey("GAD AdsBanner1") ?? ""
        bannerView.rootViewController = self
        bannerView.delegate = self
        bannerView.load(GADRequest())
        //addBannerViewToView(bannerView)
        
        logoutBtn.setTitle("logout", for: .normal)
        logoutBtn.addTarget(self, action: #selector(logout), for: .touchUpInside)
        logoutBtn.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutBtn)
        view.addConstraints([
            NSLayoutConstraint(item: logoutBtn, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: logoutBtn, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        ])
        
    }
    
    @objc func logout() {
        KeyChainManager.shared.deleteToken()
        self.performSegue(withIdentifier: K.dashboardToLoginSegue, sender: self)
    }

}

extension DashboardTabController {
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
          [NSLayoutConstraint(item: bannerView,
                              attribute: .bottom,
                              relatedBy: .equal,
                              toItem: bottomLayoutGuide,
                              attribute: .top,
                              multiplier: 1,
                              constant: 0),
           NSLayoutConstraint(item: bannerView,
                              attribute: .centerX,
                              relatedBy: .equal,
                              toItem: view,
                              attribute: .centerX,
                              multiplier: 1,
                              constant: 0)
          ])
       }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        addBannerViewToView(bannerView)
    }
}
