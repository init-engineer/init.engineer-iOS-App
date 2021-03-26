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
    
    
    /**
     
     判斷文字是否含 html tag 在裡面
     
     Test pass below
     
     let source2 = """
             懷念以前會放全平臺留言網址的版本：<br /><a href="https://kaobei.engineer/cards/show/6003" class="ex_link meta" rel="nofollow" target="_blank"><img src="https://imgs.plurk.com/QzJ/5av/q13Zcyav6hjIhpIBjemKFrS2Qck_mt.jpg" height="40px">純靠北工程師 | 原來現在找免費勞工寫專案已經不稀奇了，最新的找法是上工程師社群找付費勞工，而且不是付勞...</a>
     """
     
     let source = """
             https://zh.wikipedia.org/wiki/%E5%BE%B7%E5%9B%BD%E5%9D%A6%E5%85%8B%E9%97%AE%E9%A2%98
     """
     
     let source0 = """
             <a href="https://www.facebook.com/init.kobeengineer/photos/a.1416496745064002/3792070824173237/" class="ex_link meta" rel="nofollow"><img src="https://imgs.plurk.com/QzJ/KKD/dW1Ftfknh3KQ661wcVKMQVSqFJU_mt.jpg" height="40px">純靠北工程師 - #純靠北工程師4mr ---------- 原來現在找免費勞工寫專案已經不稀奇了，最新...</a>
     """
     
     */
    var hasHTMLTag: Bool {
        let validateTest = NSPredicate(format:"SELF MATCHES %@", ".*<[a-z][\\s\\S]*>.*")
        return validateTest.evaluate(with: self)
    }
}
