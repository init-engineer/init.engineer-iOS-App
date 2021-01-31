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
    struct Default {
        static let textColor = UIColor.init(red: 0x28/255.0, green: 0xa7/255.0, blue: 0x45/255.0, alpha: 1.0)
        static let backgroundColor = UIColor.init(red: 0x21/255.0, green: 0x25/255.0, blue: 0x29/255.0, alpha: 1.0)
        static let buttonTextColor = UIColor.init(red: 0x00/255.0, green: 0x7b/255.0, blue: 0xff/255.0, alpha: 1.0)
    }
}

struct FontConstant {
    struct Default {
        static let text = UIFont.init(name: "FixedsysTTF", size: 16.0)!
        static let title = UIFont.init(name: "FixedsysTTF", size: 36.0)!
    }
}
