//
//  SearchRepositoriesService.swift
//  GitRepositories
//
//  Created by Luiz Fernando on 01/10/18.
//  Copyright © 2018 Luiz Fernando. All rights reserved.
//

import Foundation

struct SearchRepositoriesService: BaseServiceAPI {
    internal func requestRepositories(page: Int,
                                      completion: @escaping (ServicesAPIResult<[Repository], String>) -> Void) {
        let endpoint = RequestData(path: .allRepositories, method: .get, params: ["page" : page])
        
        self.request(endpoint: endpoint) { repositoriesResult in
            
            switch repositoriesResult {
            case .success(let json):
                var repositories: [Repository] = []
                if let responseJSONData = json as? [String: Any] {
                    if let responseData = ResponseModel.decode(from: responseJSONData) {
                        if let items = responseData.items {
                            repositories = items
                        }
                    }
                }
                completion(ServicesAPIResult.success(repositories))
            case .failure(let error):
                completion(ServicesAPIResult.failure(error))
            }
        }
    }
}
