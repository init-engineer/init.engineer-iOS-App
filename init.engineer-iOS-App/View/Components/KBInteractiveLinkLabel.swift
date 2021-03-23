//
//  KBInteractiveLinkLabel.swift
//  init.engineer-iOS-App
//
//  Created by stephen on 2021/3/20.
//  Copyright © 2021 Kantai Developer. All rights reserved.
//

import UIKit

private extension String {
    
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

extension UIColor {
    func toHexString() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        getRed(&r, green: &g, blue: &b, alpha: &a)

        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0

        return String(format:"#%06x", rgb)
    }
}

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
    
    func configure() {
        isUserInteractionEnabled = true
        addGestureRecognizer(tap)
    }
    
    @objc func actionTap(tap: UITapGestureRecognizer) {
        let point = tap.location(in: self)
        isTapOnTopOfActivateLink(point: point)
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
    
    func setAttributedTextWithHTMLStyle(source: String) {
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
            """, source).getNSAttributedStringFromHTMLTag()
    }
}
