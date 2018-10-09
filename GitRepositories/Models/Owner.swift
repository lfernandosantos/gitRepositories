//
//  Owner.swift
//  GitRepositories
//
//  Created by Luiz Fernando on 02/10/18.
//  Copyright © 2018 Luiz Fernando. All rights reserved.
//

import Foundation

struct Owner: Codable {
    let id:             Int?
    let login:          String?
    let avatar:         String?
    let urlProfile:     String?
    
    enum CodingKeys: String, CodingKey {
        case id         = "id"
        case login      = "login"
        case avatar     = "avatar_url"
        case urlProfile = "url"
    }
    
    static func decode(from json: [String: Any]) -> Owner? {
        if let jsonData = try? JSONSerialization.data(withJSONObject: json, options: []) {
            if let decodedObject = try? JSONDecoder().decode(Owner.self, from: jsonData) {
                return decodedObject
            }
        }
        return nil
    }

    static func from(coreData: OwnerEntity?) -> Owner {
        let model = Owner(id: Int(coreData?.id ?? 0), login: coreData?.login, avatar: coreData?.avatar, urlProfile: coreData?.urlProfile)

        return model
    }
}
