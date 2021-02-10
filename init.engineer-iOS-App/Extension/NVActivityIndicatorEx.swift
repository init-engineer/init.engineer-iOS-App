//
//  NVActivityIndicator.swift
//  init.engineer-iOS-App
//
//  Created by Chen, Yuting | Eric | RP on 2021/02/11.
//  Copyright © 2021 Kantai Developer. All rights reserved.
//

import NVActivityIndicatorView

extension NVActivityIndicatorType {
    static func randomPick() -> NVActivityIndicatorType {
        return NVActivityIndicatorType.allCases.randomElement() ?? NVActivityIndicatorType.audioEqualizer
    }
}
