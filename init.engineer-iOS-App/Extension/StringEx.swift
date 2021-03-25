//
//  StringEx.swift
//  init.engineer-iOS-App
//
//  Created by horo on 2021/02/11.
//  Copyright © 2021 Kantai Developer. All rights reserved.
//

import Foundation

extension String {
    static func tagConvert(from id: Int) -> String {
        var tag = ""
        var carry = id
        while carry > 0 {
            tag = digitMapping(from: carry % 36) + tag
            carry = carry / 36
        }
        tag = "#純靠北工程師" + tag
        return tag
    }
    static private func digitMapping(from num: Int) -> String { //
        let convertMap = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
        return convertMap[num]
    }
    
    
    /**
     Get NSAttributedString from HTML-string.
     
     ### Chinese description
     將 HTML-string 轉換成 NSAttributedString
    
     - Returns: NSAttributedString? (return nil if not HTML-string)
     */
    func getNSAttributedStringFromHTMLTag() -> NSAttributedString? {
        guard let data = self.data(using: .utf8) else {
            return nil
        }
        do {
            return try NSAttributedString(
                data: data,
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil
            )
        } catch {
            print(error.localizedDescription)
            return  nil
        }
    }
}
