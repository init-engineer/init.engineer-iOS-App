//
//  KBInteractiveLinkLabel.swift
//  init.engineer-iOS-App
//
//  Created by stephen on 2021/3/20.
//  Copyright © 2021 Kantai Developer. All rights reserved.
//

import UIKit

// KB 靠北工程師縮寫
final class KBInteractiveLinkLabel: UILabel {
    
    private lazy var tap: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(actionTap))
        tap.numberOfTapsRequired = 1
        return tap
    }()
        
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        configure()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    private func configure() {
        isUserInteractionEnabled = true
        addGestureRecognizer(tap)
    }
    
    /// 使用者是否點擊在有效的連結上
    ///
    /// - Parameter point: User tap location point
    private func isTapOnTopOfActivateLink(point: CGPoint) {
        // Configure NSTextContainer
        let textContainer = NSTextContainer(size: bounds.size)
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = lineBreakMode
        textContainer.maximumNumberOfLines = numberOfLines
        
        // Configure NSLayoutManager and add the text container
        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(textContainer)
        
        guard let attributedText = attributedText else {
            return
        }
        
        // Configure NSTextStorage and apply the layout manager
        let textStorage = NSTextStorage(attributedString: attributedText)
        textStorage.addAttribute(NSAttributedString.Key.font,
                                 value: font!,
                                 range: NSRange(location: 0, length: attributedText.length))
        textStorage.addLayoutManager(layoutManager)
        
        // Get the tapped character location
        let locationOfTouchInLabel = point
        
        // account for text alignment and insets
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        var alignmentOffset: CGFloat = 0.0
        switch textAlignment {
        case .left, .natural, .justified:
            alignmentOffset = 0.0
        case .center:
            alignmentOffset = 0.5
        case .right:
            alignmentOffset = 1.0
        @unknown default:
            fatalError("alignment out of support boundary")
        }
        
        let xOffset = ((bounds.size.width - textBoundingBox.size.width) * alignmentOffset) - textBoundingBox.origin.x
        let yOffset = ((bounds.size.height - textBoundingBox.size.height) * alignmentOffset) - textBoundingBox.origin.y
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - xOffset, y: locationOfTouchInLabel.y - yOffset)
        
        // Which character was tapped
        let characterIndex = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        // Work out how many characters are in the string up to and including the line tapped, to ensure we are not off the end of the character string
        let lineTapped = Int(ceil(locationOfTouchInLabel.y / font.lineHeight)) - 1
        let rightMostPointInLineTapped = CGPoint(x: bounds.size.width, y: font.lineHeight * CGFloat(lineTapped))
        
        let charsInLineTapped = layoutManager.characterIndex(for: rightMostPointInLineTapped, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
                
        guard characterIndex < charsInLineTapped else {
            return
        }
        
        // Open safari while link available
        let attributeName = NSAttributedString.Key.link
        
        guard let value =
                self.attributedText?.attribute(attributeName, at: characterIndex, effectiveRange: nil) else {
            return
        }
        
        guard let aURL = value as? URL, UIApplication.shared.canOpenURL(aURL) else {
            return
        }
        UIApplication.shared.open(aURL)
    }
    
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
    private func maybeTransform2HTML(input: String) -> String {
        
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

    @objc func actionTap(tap: UITapGestureRecognizer) {
        let point = tap.location(in: self)
        isTapOnTopOfActivateLink(point: point)
    }
    
    
    /**
     
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
    private func hasHTMLTag(_ value:String) -> Bool {
        let validateTest = NSPredicate(format:"SELF MATCHES %@", ".*<[a-z][\\s\\S]*>.*")
        return validateTest.evaluate(with: value)
    }
}

// ******************************************
//
// MARK: - Public methods
//
// ******************************************
extension KBInteractiveLinkLabel {
    
    func setAttributedTextWithHTMLStyle(source: String) {
        
//        print("source \(source)")
            
        let string = hasHTMLTag(source) ? source : maybeTransform2HTML(input: source)
        
        attributedText = String(format: """
            <style>
                * {
                    color: \(textColor.toHexString());
                    font-size: 18px
                }
                img {
                    width: 200px;
                    height: 200px;
                }
            </style>
            <span>%@</span>
            """, string).getNSAttributedStringFromHTMLTag()
    }
}
