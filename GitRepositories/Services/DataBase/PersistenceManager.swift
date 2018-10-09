//
//  PersistenceManager.swift
//  GitRepositories
//
//  Created by Luiz Fernando dos Santos on 08/10/18.
//  Copyright © 2018 Luiz Fernando. All rights reserved.
//

import Foundation
import CoreData

final class PersistenceManager {

    private init() {}

    static let shared = PersistenceManager()

    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "GitRepositories")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    lazy var context = persistentContainer.viewContext

    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func fetch<T: NSManagedObject> (_ objectType: T.Type) -> [T] {
        let entityName = String(describing: objectType)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)

        do {
            let fetchedObjects = try context.fetch(fetchRequest) as? [T]
            return fetchedObjects ?? [T]()
        } catch (let error) {
            print(error)
            return [T]()
        }
    }

    func saveAnyObject<T: NSManagedObject>(_ object: T) {

        var obj = T(context: context)
        obj = object
        print(obj)
        saveContext()
    }
}
