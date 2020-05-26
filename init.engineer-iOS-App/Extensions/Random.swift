//
//  Random.swift
//
//  Created by Darktt on 15/10/7.
//  Copyright © 2015 Darktt. All rights reserved.
//

import Foundation

// MARK: - String -

public extension String
{
    static func random(length: UInt = 15, prefix: String = "", suffix: String = "") -> String
    {
        let letters: String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        // Generator random string via letters.
        let characters: Array<Character> = (0 ..< (length * 2)).compactMap {
            
            _ in
            
            letters.randomElement()
        }
        
        var randomString = String(characters)
        
        // Trim string from random start index.
        let upperBounds: Int = randomString.count - Int(length)
        let end: Int = Int.random(in: 0 ... upperBounds)
        let startIndex: String.Index = randomString.index(randomString.startIndex, offsetBy: end)
        let endIndex: String.Index = randomString.index(startIndex, offsetBy: Int(length))
        let substring: Substring = randomString[startIndex ..< endIndex]
        
        // Append prefix and suffix
        randomString = prefix + String(substring) + suffix
        
        return randomString
    }
}
