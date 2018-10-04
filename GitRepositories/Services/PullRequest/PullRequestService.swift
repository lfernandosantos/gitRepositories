//
//  PullRequestService.swift
//  GitRepositories
//
//  Created by Luiz Fernando on 03/10/18.
//  Copyright © 2018 Luiz Fernando. All rights reserved.
//

import Foundation

struct PullRequestService: BaseServiceAPI {
    internal func requestRepositories(fullname repository: String,
                                      completion: @escaping (ServicesAPIResult<[PullRequest], String>) -> Void) {
        let endpoint = RequestData(path: .pullRequests(repository: repository), method: .get)
        
        self.request(endpoint: endpoint) { repositoriesResult in
        
            switch repositoriesResult {
            case .success(let json):
                var prs: [PullRequest] = []
                if let array = json as? [Any] {
                    for item in array {
                        if let pullRequestJSON = item as? [String: Any], let pullRequest = PullRequest.decode(from: pullRequestJSON) {
                            prs.append(pullRequest)
                        }
                    }
                }
                completion(ServicesAPIResult.success(prs))
            case .failure(let error):
                completion(ServicesAPIResult.failure(error))
            }
        }
    }
}
