//
//  NetworkManager.swift
//  Exam
//
//  Created by Neosoft on 07/12/21.
//

import Foundation

enum HttpMethod:String{
    case get = "get"
    case post = "post"
}

class NetworkManager {
    
    typealias completionHandler = (AnyObject?, Error?) -> Void
    
    static let shared = NetworkManager()
    
    func dataTask(serviceURL:String,httpMethod:HttpMethod,parameters:[String:Any]?,completion:@escaping completionHandler) -> Void {
       
        requestResource(serviceURL: serviceURL, httpMethod: httpMethod, parameters: parameters, completion: completion)
    }
    
    private func requestResource(serviceURL:String,httpMethod:HttpMethod,parameters:[String:Any]?,completion:@escaping completionHandler) -> Void {
        
        guard let requestUrl = URL(string: serviceURL) else { return }
        var request = URLRequest(url: requestUrl)
       
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = httpMethod.rawValue
        
        if (parameters != nil) {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters!, options: .prettyPrinted)
        }
        
        let sessionTask = URLSession(configuration: .default).dataTask(with: request) { (data, response, error) in
            
            if (data != nil){
                let result = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                completion (result as AnyObject, nil)
            }
                
            if (error != nil) {
                completion (nil, error!)
            }
        }
        sessionTask.resume()
    }
}

