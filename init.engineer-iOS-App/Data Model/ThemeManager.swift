//
//  ThemeManager.swift
//  init.engineer-iOS-App
//
//  Created by 楊承昊 on 2021/2/1.
//  Copyright © 2021 Kantai Developer. All rights reserved.
//

import Foundation
import UIKit

class ThemeManager {
    static let shared = ThemeManager()
    var themeExistSet = Set<String>()
    var themeExistArray = Array<String>()
    var themeList = [String: Theme]()
    init() {
        guard let data = NSDataAsset(name: "theme_options")?.data else {
           print("data not exist")
           return
        }
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(ThemeResopnse.self, from: data)
            let arr = result.themes
            for element in arr {
                themeList[element.name] = element
                themeExistSet.insert(element.name)
                themeExistArray.append(element.name)
            }
        } catch  {
            print(error)
        }
    }
    
    func getThemeValue(_ name: String) -> String {
        return themeList[name]?.value ?? ""
    }
}

class ThemeResopnse: Codable {
    let themes: [Theme]
}

class Theme: Codable {
    let name: String
    let text_color: String
    let background_color: String
    let value: String
    init(name: String, text_color: String, background_color: String, value: String) {
        self.name = name
        self.text_color = text_color
        self.background_color = background_color
        self.value = value
    }
}

