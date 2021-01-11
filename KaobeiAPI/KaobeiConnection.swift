//
//  KaobeiConnection.swift
//  KaobeiAPI
//
//  Created by horo on 10/12/20.
//  Copyright © 2020 Kantai Developer. All rights reserved.
//

import Foundation
import Alamofire

class KaobeiConnection {
    
    
    static func sendRequest<T: KaobeiRequestProtocol>(api: T) -> T.responseType? {
        
        var response: T.responseType = T.responseType.self as! T.responseType
        
        guard let requestURL = api.getAPIRequestURL() else {
            return nil
        }
        
        URLSession().articleListTask(with: api.getAPIRequestURL()!) { (data, response, error) in
            
            guard let data = data, error == nil else {
                
            }
            
            guard let result = data as KBArticleList else {
                
            }
            
            return result
        }
        
        
            
        return response
    }
}

// MARK: - URLSession response handlers

extension URLSession {
    fileprivate func codableTask<T: Codable>(with url: URL, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, response, error)
                return
            }
            
            var decoder = JSONDecoder()
            if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
                decoder.dateDecodingStrategy = .iso8601
            } else {
                decoder.dataDecodingStrategy = .base64
            }
            
            completionHandler(try? decoder.decode(T.self, from: data), response, nil)
        }
    }

    func articleListTask(with url: URL, completionHandler: @escaping (KBArticleList?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(with: url, completionHandler: completionHandler)
    }
}

// MARK: - Alamofire response handlers

extension DataRequest {
    fileprivate func decodableResponseSerializer<T: Decodable>() -> DataResponseSerializer<T> {
        return DataResponseSerializer { _, response, data, error in
            guard error == nil else { return .failure(error!) }

            guard let data = data else {
                return .failure(AFError.responseSerializationFailed(reason: .inputDataNil))
            }
            
            var decoder = JSONDecoder()
            if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
                decoder.dateDecodingStrategy = .iso8601
            } else {
                decoder.dataDecodingStrategy = .base64
            }

            return Result { try decoder.decode(T.self, from: data) }
        }
    }

    @discardableResult
    fileprivate func responseDecodable<T: Decodable>(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        return response(queue: queue, responseSerializer: decodableResponseSerializer(), completionHandler: completionHandler)
    }

    @discardableResult
    func responseWelcome(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<KBArticleList>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
