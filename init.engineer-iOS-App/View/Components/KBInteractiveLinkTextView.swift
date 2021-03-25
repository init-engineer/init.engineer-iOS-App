//
//  KBInteractiveLinkTextView.swift
//  init.engineer-iOS-App
//
//  Created by stephen on 2021/3/25.
//  Copyright © 2021 Kantai Developer. All rights reserved.
//

import UIKit

final class KBInteractiveLinkTextView: UITextView {
    
    private lazy var tap: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(actionTap))
        tap.numberOfTapsRequired = 1
        return tap
    }()
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        configure()
    }
        
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
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
        
        // Configure NSLayoutManager and add the text container
        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(textContainer)

        guard let attributedText = attributedText, let font = font else {
            return
        }

        // Configure NSTextStorage and apply the layout manager
        let textStorage = NSTextStorage(attributedString: attributedText)
        textStorage.addAttribute(NSAttributedString.Key.font,
                                 value: font,
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

        Utility.maybeOpenSafari(attributedText: self.attributedText, location: characterIndex, effectiveRange: nil)
    }
    
    @objc func actionTap(tap: UITapGestureRecognizer) {
        let point = tap.location(in: self)
        isTapOnTopOfActivateLink(point: point)
    }
}

// ******************************************
//
// MARK: - Public methods
//
// ******************************************
extension KBInteractiveLinkTextView {
    
    func setAttributedTextWithHTMLStyle(source: String) {
    
        let string = source.hasHTMLTag ? source : Utility.maybeTransform2HTML(input: source)
    
        attributedText = String(format: """
            <style>
                img {
                    width: 200px;
                    height: 200px;
                }
                * {
                    color: \(textColor?.toHexString() ?? "black");
                    font-size: 18px
                }
            </style>
            <span>%@</span>
            """, string).getNSAttributedStringFromHTMLTag()
    }
}
