//
//  HostingController.swift
//  init.engineer-iOS-App
//
//  Created by Eden on 2020/5/26.
//  Copyright © 2020 Kantai Developer. All rights reserved.
//

import SwiftUI

public class HostingController<Content>: UIHostingController<Content> where Content: View
{
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
    }
    
    public override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        
        return .fade
    }
    
    public override var prefersStatusBarHidden: Bool {
        
        return false
    }
}

