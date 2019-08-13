//
//  NetworkManager.swift
//  SpotifyDemo
//
//  Created by Kedar Sukerkar on 13/08/19.
//  Copyright © 2019 Kedar Sukerkar. All rights reserved.
//

import Foundation
import Alamofire

enum CustomError: Error {
    case NoInternet
}

extension CustomError : CustomStringConvertible {
    var description: String{
        switch self {
        case .NoInternet:
            return "No internet Connection"
        }
    }
    
    var localizedDescription: String{
        switch self {
        case .NoInternet:
            return "No internet Connection"
        }
    }
}

class ILMagentoManager: NSObject{
    static let shared = ILMagentoManager()
    private override init() {}
    
    
    public typealias responseModel = (_ response: Any? , _ error: Error? , _ statusCode: Int?) -> Void
    
    
    let alamoFireManager: SessionManager = {
        let configuration = URLSession.shared.configuration
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 60
        
        return SessionManager(configuration: configuration)
    }()
    
    func sendRawDataRequest(methodType:HTTPMethod , apiName:String , parameters: [String: Any]?, headers: [String: String]?, encoding:ParameterEncoding = JSONEncoding.prettyPrinted, baseUrl: String, completionHandler:@escaping responseModel){
 
            DispatchQueue.global(qos: .background).async { [weak self] in
                var request = URLRequest(url: URL(string: baseUrl + apiName)!)
                request.httpMethod = methodType.rawValue
                request.httpBody = try? JSONSerialization.data(withJSONObject: parameters ?? [:])
                request.allHTTPHeaderFields = headers
                
                self?.alamoFireManager.request(URL(string: baseUrl + apiName)!, method: methodType, parameters: parameters, encoding: JSONEncoding(), headers: headers).responseJSON(completionHandler: { (response) in
                    completionHandler(response.result.value, response.error, response.response?.statusCode)
                })
            }
       
    }
    
    func sendRequest(methodType:HTTPMethod , apiName:String , parameters:[String: Any]? , headers: [String: String]?,encoding:ParameterEncoding = JSONEncoding.prettyPrinted,isRefreshRequest: Bool = false, baseURL: String,completionHandler:@escaping responseModel){
        
            DispatchQueue.global(qos: .background).async { [weak self] in
                
                let urlString = baseURL + apiName.replacingOccurrences(of: " ", with: "%20")
                
                self?.alamoFireManager.request(URL(string: urlString)!, method: methodType, parameters: parameters, encoding: JSONEncoding(), headers: headers).responseJSON(completionHandler: { (response) in
                    completionHandler(response.result.value, response.error, response.response?.statusCode)
                    
                })
            }
        
        
    }
    
    
    
}
