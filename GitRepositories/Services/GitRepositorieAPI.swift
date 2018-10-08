//
//  GitRepositorieAPI.swift
//  GitRepositories
//
//  Created by Luiz Fernando on 01/10/18.
//  Copyright © 2018 Luiz Fernando. All rights reserved.
//

import Foundation

protocol GitRepoAPIPath {
    var baseURL: URL { get }
    var path: String { get }
}

enum GitRepoAPI {
    case allRepositories
    case pullRequests(repository: String)
}

extension GitRepoAPI: GitRepoAPIPath {
    
    public var baseURL: URL {
        return URL(string: "https://api.github.com/")!
    }
    
    var path: String {
        switch self {
        case .allRepositories:
           return "search/repositories?q=language:Swift&sort=stars&page=1/"
        case .pullRequests(let repository):
            return "repos/\(repository)/pulls"
        }
    }
}
