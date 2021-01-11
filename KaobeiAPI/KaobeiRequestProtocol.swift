//
//  KaobeiRequestProtocol.swift
//  KaobeiAPI
//
//  Created by horo on 10/20/20.
//  Copyright © 2020 Kantai Developer. All rights reserved.
//

import Foundation
import Alamofire

public protocol KaobeiRequestProtocol {
    var baseURL: URL? { get }
    associatedtype responseType: Codable // or a protocol based on codable to receive data
    var apiPath: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var parameters: [String: Any]? { get }
}

extension KaobeiRequestProtocol {
    var baseURL: URL? {
        let basePath = KaobeiURL.basePath
        return URL(string: basePath)
    }
    
    var headers: HTTPHeaders? {
        return getOAuthHeader()
    }
    
    var parameters: [String: Any]? {
        return getDefaultParameters()
    }
    
    func getOAuthHeader() -> HTTPHeaders {
        var header = [String: String]()
        // get OAuth token from app datamanager
        // header["Authorization"] = "OAuth2 \(String(describing: token))"
        
        return header
    }
    
    func getDefaultParameters() -> [String: Any] {
        var parameters = [String: Any]()
        
        
        return parameters
    }
    
    func getAPIRequestURL() -> URL? {
        return baseURL?.appendingPathComponent(apiPath)
    }
}
