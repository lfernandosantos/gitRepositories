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

            Alamofire.request(endpoint.path, method: endpoint.method, parameters: endpoint.params,
                              encoding: URLEncoding.queryString).responseJSON { result in
                            
                                switch result.result {
                                case .success(let response):
                                    if result.response?.statusCode == 200 || result.response?.statusCode == 201 {
                                        self.extractTotalPages(response: result.response)

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
    
    func extractTotalPages( response: HTTPURLResponse?) {
        if let link = response?.allHeaderFields["Link"] as? String, !link.isEmpty {
            let arr = link.components(separatedBy: ",")
            for index in 0...(arr.count-1) {
                if arr[index].contains("rel=\"last\"") {
                    self.getTotalPages(string: arr[index])
                }
            }
        } else {
            let userInfo: [String: Any] = ["total_pages" : 1 as Any]
            self.sendNotification(userInfo: userInfo)
        }
    }

    private func getTotalPages(string: String) {
        let str1 = string.replacingOccurrences(of: "; rel=\"last\"", with: "")
        let str2 = str1.replacingOccurrences(of: " <", with: "")
        let urlStr = str2.replacingOccurrences(of: ">", with: "")

        guard let url = URLComponents(string: urlStr) else {
            return
        }
        let userInfo: [String : Any]
        if let totalPages = url.queryItems?.first(where: { $0.name == "page" })?.value {
            userInfo = ["total_pages" : Int(totalPages)! as Any]
        } else {
            userInfo = ["total_pages" : 1]
        }
        self.sendNotification(userInfo: userInfo)
    }

    private func sendNotification(userInfo: [String : Any]) {
            let str = "total.pages.notification"
            NotificationCenter.default.post(name: Notification.Name.init(rawValue: str),
                                            object: nil,
                                            userInfo: userInfo)

//        if let total = userInfo["total_pages"] as? Int {
//            var userDefaults = UserDefaults.standard
//            userDefaults.set(total, forKey: str)
//            userDefaults.synchronize()
//        }
    }

    private func handleAPIError(response: Any) -> String {
        guard let json = response as? [String: Any] else {
            return "API ERROR"
        }
        return json["message"] as! String
    }
}
