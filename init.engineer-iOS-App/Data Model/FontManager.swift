//
//  fontManager.swift
//  init.engineer-iOS-App
//
//  Created by 楊承昊 on 2021/2/1.
//  Copyright © 2021 Kantai Developer. All rights reserved.
//

import Foundation
import UIKit

class FontManager {
    static let shared = FontManager()
    var fontExistSet = Set<String>()
    var fontExistArray = Array<String>()
    var fontList = [String: Font]()
    init() {
        guard let data = NSDataAsset(name: "font_options")?.data else {
           print("data not exist")
           return
        }
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(FontResopnse.self, from: data)
            let arr = result.options
            for element in arr {
                fontList[element.name] = element
                fontExistSet.insert(element.name)
                fontExistArray.append(element.name)
            }
        } catch {
            print(error)
        }
    }
    
    func getFontValue(_ name: String) -> String {
        return fontList[name]?.value ?? ""
    }
}

class FontResopnse: Codable {
    let options: [Font]
}

class Font: Codable {
    let name: String
    let font: String
    let value: String
    init(name: String, fontName: String, value: String) {
        self.name = name
        self.font = fontName
        self.value = value
    }
}
