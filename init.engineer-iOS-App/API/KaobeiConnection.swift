//
//  KaobeiConnection.swift
//  KaobeiAPI
//
//  Created by horo on 10/12/20.
//

import Foundation
import Alamofire

public class KaobeiConnection {
    public static func sendRequest<T: KaobeiRequestProtocol>(api: T, apiData: @escaping (AFDataResponse<T.responseType>) -> ()){
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
    
    public static func uploadRequest(api: KBPostUserPublishing, with fileExtension: String, apiData: @escaping (AFDataResponse<KBPostUserPublishing.responseType>) -> ()) {
        if let apiURL = api.getAPIRequestURL() {
            AF.upload(multipartFormData: {multipartData in
                for (key, value) in api.httpBody {
                    multipartData.append((value as! String).data(using: .utf8)!, withName: key)
                }
                guard let image = api.imageData else {
                    return
                }
                multipartData.append(image, withName: "avatar", fileName: "iOSAPP \(Date.init().description).\(fileExtension)")
                
            }, to: apiURL, headers: api.headers).responseDecodable(of: KBUserPublishing.self) { (response) in
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

