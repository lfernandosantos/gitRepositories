//
//  RequestModel.swift
//  GitRepositories
//
//  Created by Luiz Fernando on 02/10/18.
//  Copyright © 2018 Luiz Fernando. All rights reserved.
//

import Foundation

struct ResponseModel: Codable {
    let totalCount:    Int?
    let items:          [Repository]?
    
    enum CodingKeys: String, CodingKey {
        case totalCount      = "total_count"
        case items           = "items"
    }
    
    static func decode(from json: [String: Any]) -> ResponseModel? {
        if let jsonData = try? JSONSerialization.data(withJSONObject: json, options: []) {
            if let decodedObject = try? JSONDecoder().decode(ResponseModel.self, from: jsonData) {
                return decodedObject
            }
        }
        return nil
    }
}
