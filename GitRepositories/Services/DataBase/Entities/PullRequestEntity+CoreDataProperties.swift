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

    func getFromCoreData() -> PullRequestEntity? {
        let persistence = PersistenceManager.shared
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PullRequestEntity")
        fetchRequest.predicate = NSPredicate(format: "id=%@", "\(id)")

        do {
            if let results = try? persistence.context.fetch(fetchRequest) as? [PullRequestEntity] {
                if results?.count ?? 0 > 0 {
                    return results?[0] ?? nil
                }
            }
        }
        return nil
    }

    func savedOnCoreData() -> Bool {
        if getFromCoreData() != nil {
            return true
        }
        return false
    }

    static func getAllFromCoreData() -> [PullRequestEntity]? {
        let persistence = PersistenceManager.shared
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PullRequestEntity")

        do {
            if let results = try? persistence.context.fetch(fetchRequest) as? [PullRequestEntity] {
                return results
            }
        }
        return nil
    }
}

extension PullRequest {
    var entityCoreData: PullRequestEntity { get{
        return PullRequestEntity.from(pull: self)
        }}
}
