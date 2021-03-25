//
//  Utility.swift
//  init.engineer-iOS-App
//
//  Created by stephen on 2021/3/25.
//  Copyright © 2021 Kantai Developer. All rights reserved.
//

import Foundation

enum Utility {
    
    /**
     情境
     
     * 4mr 有 html 語法，所以用 html render 出來，那這樣 label 才能解決 圖片顯示 以及 link 的點擊事情

     * 但又發現 4nu 有 server 傳過來的會是如下

     https://zh.wikipedia.org/wiki/%E5%BE%B7%E5%9B%BD%E5%9D%A6%E5%85%8B%E9%97%AE%E9%A2%98

     所以基於以上兩者推演出三種可能來源

     1. 有 html 語法，一樣用 html render （ 如 4mr ）
     2. 沒有 html 語法，如上面這次 4nu 的狀態（ 如 4nu ）
     3. 沒有 html 語法，但有可能包含其他文字比如

     a text https://link1 b text https://link2
     
     所以解法採用如果發現 link 的話，那就 replace 成 <a href="https://link1">https://link1</a>
     
     */
    static func maybeTransform2HTML(input: String) -> String {
        
        guard let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else {
            // If fail to try, return origin sourece
            return input
        }
        
        let matches = detector.matches(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count))
        var inputCopy = input
        
        for match in matches {
            guard let range = Range(match.range, in: input) else { continue }
            let foundURL = input[range]
            let display = (foundURL.removingPercentEncoding ?? String(foundURL))
            inputCopy = inputCopy.replacingOccurrences(of: foundURL, with: String(format: "<a href=\"%@\">%@</a>", foundURL as CVarArg, display))
        }
        return inputCopy
    }
}
