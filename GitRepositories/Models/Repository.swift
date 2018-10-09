//
//  Repository.swift
//  GitRepositories
//
//  Created by Luiz Fernando on 02/10/18.
//  Copyright © 2018 Luiz Fernando. All rights reserved.
//

import Foundation

struct Repository: Codable {
    let id:             Int?
    let name:           String?
    let fullname:       String?
    let description:    String?
    let language:       String?
    let owner:          Owner?
    let stars:          Int?
    let forks:          Int?
    
    enum CodingKeys: String, CodingKey {
        case id              = "id"
        case name            = "name"
        case fullname        = "full_name"
        case description     = "description"
        case language        = "language"
        case owner           = "owner"
        case stars           = "stargazers_count"
        case forks           = "forks_count"
    }
    
//    make generic class in data manager class
    static func decode(from json: [String: Any]) -> Repository? {
        if let jsonData = try? JSONSerialization.data(withJSONObject: json, options: []) {
            if let decodedObject = try? JSONDecoder().decode(Repository.self, from: jsonData) {
                return decodedObject
            }
        }
        return nil
    }

    static func from(coreData: RepositoryEntity) -> Repository {
        let model = Repository(id: Int(coreData.id), name: coreData.name, fullname: coreData.fullname, description: coreData.description, language: coreData.language, owner: Owner.from(coreData: coreData.user), stars: Int(coreData.stars), forks: Int(coreData.forks))
        return model
    }
}
