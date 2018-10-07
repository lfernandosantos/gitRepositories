//
//  PullRequest.swift
//  GitRepositories
//
//  Created by Luiz Fernando on 02/10/18.
//  Copyright © 2018 Luiz Fernando. All rights reserved.
//

import Foundation

struct PullRequest: Codable {
    let id:             Int?
    let url:            String?
    let title:          String?
    let body:           String?
    let createdDate:    String?
    let user:           Owner?
    
    enum CodingKeys: String, CodingKey {
        case id             = "id"
        case url            = "html_url"
        case title          = "title"
        case body           = "body"
        case createdDate    = "created_at"
        case user           = "user"
    }
    
    static func decode(from json: [String: Any]) -> PullRequest? {
        if let jsonData = try? JSONSerialization.data(withJSONObject: json, options: []) {
            if let decodedObject = try? JSONDecoder().decode(PullRequest.self, from: jsonData) {
                return decodedObject
            }
        }
        return nil
    }
}
