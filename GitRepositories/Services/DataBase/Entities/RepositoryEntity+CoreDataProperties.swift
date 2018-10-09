//
//  RepositoryEntity+CoreDataProperties.swift
//  
//
//  Created by Luiz Fernando dos Santos on 08/10/18.
//
//

import Foundation
import CoreData


extension RepositoryEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RepositoryEntity> {
        return NSFetchRequest<RepositoryEntity>(entityName: "RepositoryEntity")
    }

    @NSManaged public var id: Int32
    @NSManaged public var name: String?
    @NSManaged public var fullname: String?
    @NSManaged public var descriptionRepository: String?
    @NSManaged public var language: String?
    @NSManaged public var stars: Int32
    @NSManaged public var forks: Int32
    @NSManaged public var user: OwnerEntity?

    static func from(repository: Repository) -> RepositoryEntity {
        let persistence = PersistenceManager.shared
        let entity = RepositoryEntity(context: persistence.context)
        if let id = repository.id {
            entity.id = Int32(id)
        }
        entity.name = repository.name
        entity.fullname = repository.fullname
        entity.descriptionRepository = repository.description
        entity.language = repository.language
        entity.stars = Int32(repository.stars  ?? 0)
        entity.forks = Int32(repository.forks ?? 0)
        if let owner = repository.owner {
            entity.user = OwnerEntity.from(owner: owner)
        }
        return entity
    }

    func getFromCoreData() -> RepositoryEntity? {
        let persistence = PersistenceManager.shared
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "RepositoryEntity")
        fetchRequest.predicate = NSPredicate(format: "id=%@", "\(id)")

        do {
            if let results = try? persistence.context.fetch(fetchRequest) as? [RepositoryEntity] {
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

    static func getAllFromCoreData() -> [RepositoryEntity]? {
        let persistence = PersistenceManager.shared
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "RepositoryEntity")

        do {
            if let results = try? persistence.context.fetch(fetchRequest) as? [RepositoryEntity] {
                return results
            }
        }
        return nil
    }
}

extension Repository {
    var entityCoreData: RepositoryEntity { get{
        return RepositoryEntity.from(repository: self)
        }}
}
