//
//  CoreDataManager.swift
//  CurrencyConverter
//
//  Created by Pushpank Kumar on 26/01/25.
//

import Foundation
import CoreData

protocol CoreDataManaging {
    var persistentContainer: NSPersistentContainer { get }
    func saveContext()
}

final class CoreDataManager: CoreDataManaging {
    static let shared = CoreDataManager()

    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CurrencyConverter")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                debugPrint("Failed to load Core Data stack: \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext() {
        let context = persistentContainer.viewContext
        guard context.hasChanges else { return }

        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            debugPrint("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
