
//
//  Repository.swift
//  DeveloperChallenge
//
//  Created by Robert Bernardini on 4/16/19.
//  Copyright © 2019 Qantas Assure. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

// Repository Protocol
protocol Repository {
    var updateItemsProgress: BehaviorRelay<Float> { get }
    func fetchItems() -> [RedditDisplayable]
    func insertInitialItemsIntoDatabase() -> Single<Void>
    func downloadItemsToDatabase() -> Single<Void>
    func cancelDownload()
}

// Concrete class that implements the Repository protocol.
// This class is used to return any data requested by the view model and is responsible
// for coordinating the fetching and saving of data with the Service layer.
// It also returns the progress of the downloadRedditsToDatabase function.
class RepositoryImp: Repository {
    
    var dataService: DataService = DataServiceImp.shared
    var apiService: APIService = APIServiceImp.shared
    var updateItemsProgress = BehaviorRelay<Float>(value: 0)
    let disposeBag = DisposeBag()
    
    func fetchItems() -> [RedditDisplayable] {
        return dataService.fetchItems()
    }
    
    func insertInitialItemsIntoDatabase() -> Single<Void> {
        return dataService.insertInitialItemsIntoDatabase().observeOn(MainScheduler.instance)
    }
    
    func downloadItemsToDatabase() -> Single<Void> {
        updateItemsProgress.accept(0.2)
        guard let url = URL(string: Constants.redditURL) else {
            let error = RedditError.invalidURL
            return Single.error(error)
        }
        return apiService.fetchData(at: url).flatMap({ [unowned self] (location) -> Single<Void> in
            guard let path = location,
                let contents = try self.dataService.getContentsOfFile(at: path) else {
                return Single.just(())
            }
            
            self.updateItemsProgress.accept(0.5)
            var reddits: [RedditAPIModel] = []
            try contents.forEach({ (url) in
                let data = try Data(contentsOf: url)
                let apiModel = try JSONDecoder().decode(APIModel.self, from: data)
                let contentReddits = apiModel.data.children.compactMap({ $0.reddit })
                reddits.append(contentsOf: contentReddits)
            })
            self.updateItemsProgress.accept(0.8)
            
            // Remove any duplicate Reddit API Models from the array
            reddits.removeDuplicates()
            self.updateItemsProgress.accept(0.9)

            return self.dataService.save(reddits)
        }).observeOn(MainScheduler.instance)
    }
    
    func cancelDownload() {
        apiService.cancelDownload()
    }
}
