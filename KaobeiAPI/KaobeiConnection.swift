//
//  KaobeiConnection.swift
//  KaobeiAPI
//
//  Created by horo on 10/12/20.
//  Copyright © 2020 Kantai Developer. All rights reserved.
//

import Foundation
import Alamofire

public class KaobeiConnection {
    static func sendRequest<T: KaobeiRequestProtocol>(api: T, apiData: @escaping (AFDataResponse<T.responseType>) -> ()){
        if let apiURL = api.getAPIRequestURL() {
            AF.request(apiURL, method: api.method, parameters: api.parameters, headers: api.headers).responseDecodable(of: T.responseType.self) { (response) in
                switch response.result{
                    case .success(_):
                        print("Data received")
                        break
                    case .failure(_):
                        if let status = response.response?.statusCode {
                            print("Data failure with: \(status)")
                        }
                        break
                }
                
                apiData(response)
            }
        }
    }
}

