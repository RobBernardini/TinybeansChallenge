
//
//  ViewModel.swift
//  DeveloperChallenge
//
//  Created by Robert Bernardini on 4/16/19.
//  Copyright © 2019 Qantas Assure. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

// View Model Protocol
protocol ViewModel {
    var disposeBag: DisposeBag { get }
    var refreshProgress: BehaviorRelay<Float> { get }
    func setupDatabase() -> Single<[RedditDisplayable]>
    func refreshItems() -> Single<[RedditDisplayable]>
    func cancelDownload()
}

// Concrete class that implements the View Model protocol.
// This class is used to manage the data collection, storage and fecthing from the
// Repository. It calls the functions to setup the database and to download/save the
// Reddit data and once these are performed it calls the fetch data function to return
// the displayable data to the view controller to be presented in the user.
class ViewModelImp: ViewModel {
    
    var repository: Repository = RepositoryImp()
    var disposeBag: DisposeBag = DisposeBag()
    
    var refreshProgress: BehaviorRelay<Float> {
        return repository.updateItemsProgress
    }
    
    func setupDatabase() -> Single<[RedditDisplayable]> {
        return repository.insertInitialItemsIntoDatabase().map({ [weak self] (_) -> [RedditDisplayable] in
            return self?.repository.fetchItems() ?? []
        })
    }
    
    func refreshItems() -> Single<[RedditDisplayable]> {
        return repository.downloadItemsToDatabase().map({ [weak self] (_) -> [RedditDisplayable] in
            return self?.repository.fetchItems() ?? []
        })
    }
    
    func cancelDownload() {
        repository.cancelDownload()
    }
}
