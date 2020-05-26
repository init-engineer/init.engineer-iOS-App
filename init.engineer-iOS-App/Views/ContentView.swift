//
//  ContentView.swift
//  init.engineer-iOS-App
//
//  Created by Eden on 2020/5/25.
//  Copyright © 2020 Kantai Developer. All rights reserved.
//

import SwiftUI

public struct ContentView: View
{
    @State
    var token: String? = nil
    
    public var body: some View {
        
        Group {
            
            if self.token == nil {
                
                LoginView(token: self.$token)
            } else {
                
                Text("Logged in")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider
{
    static var previews: some View {
        
        ContentView()
            .edgesIgnoringSafeArea(.all)
    }
}
