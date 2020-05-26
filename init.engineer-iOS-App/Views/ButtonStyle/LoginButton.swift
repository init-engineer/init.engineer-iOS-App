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
        
        RoundedRectangle(cornerRadius: 10, style: .continuous)
        .fill(Color.init("ButtonBackgroundColor"))
    }
    
    public func makeBody(configuration: Configuration) -> some View
    {
        configuration.label.padding(20.0)
            .background(self.backgroundView)
        
        
    }
}

private struct LoginButton_Previews: PreviewProvider
{
    static var previews: some View
    {
        Button("登入", action: {}).buttonStyle(LoginButtonStyle())
    }
}
