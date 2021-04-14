//
//  Comment.swift
//  init.engineer-iOS-App
//
//  Created by horo on 2021/04/15.
//

import Foundation

struct Comment {
    var name: String
    var avatar: String
    var content : String
    var created: String
    var media: Media
    
    struct Media {
        var type: String
        var connections: String
    }
    
}
