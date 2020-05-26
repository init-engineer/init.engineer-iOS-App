//
//  LoginButton.swift
//  init.engineer-iOS-App
//
//  Created by Eden on 2020/5/26.
//  Copyright © 2020 Kantai Developer. All rights reserved.
//

import SwiftUI

public struct LoginButtonStyle: ButtonStyle
{
    private var backgroundView: some View {
        
        RoundedRectangle(cornerRadius: 5.0, style: .circular)
            .fill(Color.buttonBackgroundColor)
            .frame(width: 80.0, height: 35.0, alignment: .center)
    }
    
    public func makeBody(configuration: Configuration) -> some View
    {
        configuration.label
            .background(self.backgroundView)
            .scaleEffect(configuration.isPressed ? 0.95: 1.0)
            .animation(.spring())
    }
}

struct LoginButtonStyle_Previews: PreviewProvider
{
    static var previews: some View
    {
        Button("登入", action: {})
            .foregroundColor(.white)
            .buttonStyle(LoginButtonStyle())
    }
}
