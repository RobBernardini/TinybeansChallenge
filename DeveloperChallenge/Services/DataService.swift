//
//  DataService.swift
//  DeveloperChallenge
//
//  Created by Robert Bernardini on 4/16/19.
//  Copyright © 2019 Qantas Assure. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import CoreData
import SSZipArchive

// Data Service Protocol 
protocol DataService {
    func getContentsOfFile(at path: String) throws -> [URL]?
    func insertInitialItemsIntoDatabase() -> Single<Void>
    func fetchItems() -> [RedditDisplayable]
    func save(_ items: [Reddit]) -> Single<Void>
    func resetDatabase()
}

// Concrete class that implements the Data Service protocol.
// This class is used to perform any data service functions related to Core Data and the File System.
// Fecthing from Core Data is performed on the Main Context as it will be used to update the UI.
// Saving to and deleting data from Core Data is performed on a Background Context so as not to block the Main UI Thread.
// This class also encapsulates obtaining and saving the Core Data contexts eliminating the need to call the App Delegate.
class DataServiceImp: DataService {
    
    static let shared = DataServiceImp()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Constants.databaseName)
        container.loadPersistentStores(completionHandler: { (_, error) in
            guard let error = error as NSError? else {
                return
            }
            fatalError("Unresolved error \(error), \(error.userInfo)")
        })
        
        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        container.viewContext.undoManager = nil
        container.viewContext.shouldDeleteInaccessibleFaults = true
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        return container
    }()
    
    private var backgroundContext: NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }
    
    private var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func getContentsOfFile(at path: String) throws -> [URL]? {
        let destinationURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("unarchived")
        guard SSZipArchive.unzipFile(atPath: path, toDestination: destinationURL.path) else {
            let error = RedditError.unzippingFileFailed
            throw error
        }
        return try FileManager.default.contentsOfDirectory(at: destinationURL, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles, .skipsPackageDescendants, .skipsSubdirectoryDescendants])
    }
    
    func insertInitialItemsIntoDatabase() -> Single<Void> {
        var reddits: [RedditModel] = []
        reddits.append(RedditModel(id: "0", message: "Hello world!", author: "Tim", score: 1))
        reddits.append(RedditModel(id: "1", message: "Yo!", author: "Rog", score: 2))
        reddits.append(RedditModel(id: "2", message: "Swifty", author: "Summer", score: 3))
        reddits.append(RedditModel(id: "3", message: "FooBar", author: "Stephen", score: 4))
        reddits.append(RedditModel(id: "4", message: "FizzBuzz", author: "Sherif", score: 5))
        return save(reddits)
    }
    
    func fetchItems() -> [RedditDisplayable] {
        let fetchRequest: NSFetchRequest<RedditEntity> = RedditEntity.fetchRequest()
        let dateSort = NSSortDescriptor(key: "date", ascending: false)
        let scoreSort = NSSortDescriptor(key: "score", ascending: false)
        fetchRequest.sortDescriptors = [dateSort, scoreSort]
        guard let reddits = try? mainContext.fetch(fetchRequest) else {
            return []
        }
        return reddits
    }
    
    func save(_ items: [Reddit]) -> Single<Void> {
        return Single<Void>.create(subscribe: { [unowned self] (event) -> Disposable in
            let context = self.backgroundContext
            context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
            context.undoManager = nil
            
            context.performAndWait {
                items.forEach { (reddit) in
                    // Fetch and update the already saved Reddit article otherwise insert a new article.
                    let fetchRequest: NSFetchRequest<RedditEntity> = RedditEntity.fetchRequest()
                    fetchRequest.predicate = NSPredicate(format: "identifier == %@", reddit.redditIdentifier)
                    guard let entity = try? context.fetch(fetchRequest).first else {
                        let newEntity = RedditEntity(context: context)
                        newEntity.update(with: reddit)
                        return
                    }
                    entity.update(with: reddit)
                }
                
                if context.hasChanges {
                    do {
                        try context.save()
                    } catch {
                        event(.error(error))
                    }
                    context.reset()
                }
                event(.success(()))
            }
            
            return Disposables.create()
        })
    }
    
    func resetDatabase() {
        let context = backgroundContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = RedditEntity.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        batchDeleteRequest.resultType = .resultTypeObjectIDs
        
        do {
            let deleteResult = try context.execute(batchDeleteRequest) as? NSBatchDeleteResult
            guard let objectIDs = deleteResult?.result as? [NSManagedObjectID] else {
                return
            }
            let mergeChanges = [NSDeletedObjectsKey: objectIDs]
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: mergeChanges, into: [mainContext])
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
