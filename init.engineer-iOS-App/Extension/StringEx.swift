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
}
