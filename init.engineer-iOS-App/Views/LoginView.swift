//
//  LoginView.swift
//  init.engineer-iOS-App
//
//  Created by Eden on 2020/5/26.
//  Copyright © 2020 Kantai Developer. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

public struct LoginView: View
{
    // MARK: - Properties -
    
    public var body: some View {
        
        ZStack {
            
            AnimatedImage(name: "BackgroundImage.gif")
            .aspectRatio(1.0, contentMode: .fill)
            
            VStack(alignment: .center) {
                
                Image("LogoImage")
                
                Button("登入", action: self.loginAction)
                    .foregroundColor(.white)
                .buttonStyle(LoginButtonStyle())
            }
        }
    }
    
    @Binding
    public var token: String?
    
    // MARK: - Methods -
    // MARK: Initial Method
    
    fileprivate init()
    {
        self._token = Binding(get: { "" }, set: { _ in })
    }
    
    init(token: Binding<String?>) {
        
        self._token = token
    }
}

// MARK: - Actions -

public extension LoginView
{
    func loginAction()
    {
        
    }
}

struct LoginView_Previews: PreviewProvider
{
    static var previews: some View
    {
        LoginView()
            .background(Color.black)
    }
}
