//
//  CoreDataStorage.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2024-01-05.
//

import Foundation
import UIKit
import CoreData

final class CoreDataStorage {
    lazy var persistentContainer: NSPersistentContainer = {
        let storeURL = URL.storeURL(for: Constants.SharedStorage.appGroup,
                                    databaseName: Constants.SharedStorage.databaseName)
        let storeDescription = NSPersistentStoreDescription(url: storeURL)
        let container = NSPersistentContainer(name: Constants.SharedStorage.databaseName)
        container.persistentStoreDescriptions = [storeDescription]
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    internal lazy var context = persistentContainer.viewContext

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func save(object: NSManagedObject) {
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func fetch<T: NSManagedObject>(entity: T.Type,
                                   predicate: NSPredicate? = nil,
                                   sortDescriptors: [NSSortDescriptor]? = nil) -> [T] {
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: entity))
        
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
        
        do {
            let results = try context.fetch(fetchRequest)
            return results
        } catch {
            print("Error fetching objects: \(error)")
            return []
        }
    }
}

fileprivate extension URL {
    /// Returns a URL for the given app group and database pointing to the sqlite database.
    static func storeURL(for appGroup: String, databaseName: String) -> URL {
        guard let fileContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
            fatalError("Shared file container could not be created.")
        }

        return fileContainer.appendingPathComponent("\(databaseName).sqlite")
    }
}
