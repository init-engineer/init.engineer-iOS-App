//
//  UIConstants.swift
//  init.engineer-iOS-App
//
//  Created by horo on 1/28/21.
//  Copyright © 2021 Kantai Developer. All rights reserved.
//

import Foundation
import UIKit

struct ColorConstants {
    struct Card {
        static let textColor = UIColor.init(red: 0x05/255.0, green: 0xee/255.0, blue: 0x37/255.0, alpha: 1.0)
        static let backgroundColor = UIColor.init(red: 0x18/255.0, green: 0x18/255.0, blue: 0x18/255.0, alpha: 1.0)
        static let buttonTextColor = UIColor.init(red: 0x00/255.0, green: 0x7b/255.0, blue: 0xff/255.0, alpha: 1.0)
        static let whiteTextColor = UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    struct Comment {
        static let bubbleColor = UIColor.init(red: 0x1A/255.0, green: 0x76/255.0,blue: 0xFF/255.0, alpha: 1.0)
    }
    struct Dashboard {
        static let userName = UIColor.init(white: 1.0, alpha: 1.0)
        static let userEmail = UIColor.init(white: 1.0, alpha: 1.0)
    }
}

struct FontConstant {
    struct Default {
        static let text = UIFont.init(name: "FixedsysTTF", size: 16.0)!
        static let title = UIFont.init(name: "FixedsysTTF", size: 36.0)!
    }
    struct Comment {
        static let name = UIFont.init(name: "System", size: 17.0)!
        static let platform = UIFont.init(name: "System", size: 17.0)!
        static let content = UIFont.init(name: "System", size: 17.0)!
        static let createdTime = UIFont.init(name: "System", size: 17.0)!
    }
    struct Dashboard {
        static let userName = UIFont.init(name: "FixedsysTTF", size: 24.0)!
        static let userEmail = UIFont.init(name: "FixedsysTTF", size: 22.0)!
    }
}
