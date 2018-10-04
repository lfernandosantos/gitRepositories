//
//  RequestData.swift
//  GitRepositories
//
//  Created by Luiz Fernando on 01/10/18.
//  Copyright © 2018 Luiz Fernando. All rights reserved.
//

import Foundation
import Alamofire

struct RequestData {
    let path:     URL
    let method:   HTTPMethod
    let params:   [String: Any]?
    
    init(path: GitRepoAPI, method: HTTPMethod, params: [String: Any]? = nil) {
        self.path    = URL(string: path.baseURL.absoluteString + path.path)!
        self.method  = method
        self.params  = params
    }
}
