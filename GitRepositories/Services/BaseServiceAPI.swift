//
//  RepositoriesBaseService.swift
//  GitRepositories
//
//  Created by Luiz Fernando on 01/10/18.
//  Copyright © 2018 Luiz Fernando. All rights reserved.
//

import Foundation
import Alamofire

protocol BaseServiceAPI {
    func request(endpoint: RequestData, completion: @escaping (ServicesAPIResult<Any, String>) -> Void)
}

extension BaseServiceAPI {
    func request(endpoint: RequestData, completion: @escaping (ServicesAPIResult<Any, String>) -> Void) {
        if endpoint.method == .get {
            
            Alamofire.request(endpoint.path, method: endpoint.method, parameters: nil,
                              encoding: JSONEncoding()).responseJSON { result in
                            
                                switch result.result {
                                case .success(let response):
                                    if result.response?.statusCode == 200 || result.response?.statusCode == 201 {
                                        completion(ServicesAPIResult.success(response))
                                    } else {
                                        completion(ServicesAPIResult.failure(self.handleAPIError(response: response)))
                                    }
                                case .failure(let error):
                                    completion(ServicesAPIResult.failure(error.localizedDescription))
                            }
            }
        }
    }
    
//    func extractTotalPages( response: HTTPURLResponse?) {
//        if let link = response?.allHeaderFields["link"] as? String, !link.isEmpty {
//            let arr = link.components(separatedBy: ",")
//            for index in 0...(arr.count-1) {
//                if arr[index].contains("rel=\"last\"") {
//                    self.getTotalPages(string: arr[0])
//                }
//            }
//        } else {
//            let userInfo: [String: Any] = ["total_pages" : 1 as Any]
//            //save on userdefault
//        }
//    }
    
//    private func getTotalPages(string: String) {
//        if let range = string.range(of: "?page=") {
//            let sub = String(string.suffix(from: range.upperBound))
//            let totalPage = sub.prefix(upTo: sub.index(after: sub.startIndex))
//            let userInfo: [String: Any] = ["total_pages" : Int(totalPage)! as Any]
//            print("Total of pages: \(userInfo)")
//            //save on userdefault
//        }
//    }
    
    private func handleAPIError(response: Any) -> String {
        guard let json = response as? [String: Any] else {
            return "API ERROR"
        }
        return json["message"] as! String
    }
}
