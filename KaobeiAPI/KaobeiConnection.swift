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
        let decoder = JSONDecoder()
        if let apiURL = api.getAPIRequestURL() {
            AF.request(apiURL, method: api.method).responseDecodable(of: T.responseType.self) { (response) in
                switch response.result{
                    case .success(_):
                        break
                    case .failure(_):
                        if let status = response.response?.statusCode {
                            print(status)
                        }
                        break
                }
                
                apiData(response)
            }
        }
        
    }
}

