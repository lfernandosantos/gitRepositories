//
//  OwnerEntity+CoreDataProperties.swift
//  
//
//  Created by Luiz Fernando dos Santos on 08/10/18.
//
//

import Foundation
import CoreData


extension OwnerEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OwnerEntity> {
        return NSFetchRequest<OwnerEntity>(entityName: "OwnerEntity")
    }

    @NSManaged public var id: Int32
    @NSManaged public var login: String?
    @NSManaged public var avatar: String?
    @NSManaged public var urlProfile: String?

    static func from(owner: Owner) -> OwnerEntity {
        let persistence = PersistenceManager.shared
        let entity = OwnerEntity(context: persistence.context)
        if let id = owner.id {
            entity.id = Int32(id)
        }
        entity.login = owner.login
        entity.avatar = owner.avatar
        entity.urlProfile = owner.urlProfile
        return entity
    }

}
