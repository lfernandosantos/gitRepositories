//
//  SearchGitRepositories.swift
//  GitRepositories
//
//  Created by Luiz Fernando on 01/10/18.
//  Copyright © 2018 Luiz Fernando. All rights reserved.
//

import Foundation

public enum SearchGitRepoResult<T, String> {
    case success(T)
    case failure(String)
}
