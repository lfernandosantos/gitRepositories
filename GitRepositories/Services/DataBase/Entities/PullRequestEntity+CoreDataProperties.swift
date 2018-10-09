//
//  PullRequestEntity+CoreDataProperties.swift
//  
//
//  Created by Luiz Fernando dos Santos on 08/10/18.
//
//

import Foundation
import CoreData


extension PullRequestEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PullRequestEntity> {
        return NSFetchRequest<PullRequestEntity>(entityName: "PullRequestEntity")
    }

    @NSManaged public var id: Int32
    @NSManaged public var url: String?
    @NSManaged public var title: String?
    @NSManaged public var body: String?
    @NSManaged public var createdDate: String?
    @NSManaged public var user: OwnerEntity?

    static func from(pull: PullRequest) -> PullRequestEntity {
        let persistence = PersistenceManager.shared
        let entity = PullRequestEntity(context: persistence.context)
        if let id = pull.id {
            entity.id = Int32(id)
        }
        entity.url = pull.url
        entity.title = pull.title
        entity.body = pull.body
        entity.createdDate = pull.createdDate
        if let owner = pull.user {
            entity.user = OwnerEntity.from(owner: owner)
        }
        entity.createdDate = pull.createdDate
        
        return entity
    }
}
