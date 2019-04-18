//
//  DeveloperChallengeTests.swift
//  DeveloperChallengeTests
//
//

import XCTest
import RxSwift
@testable import DeveloperChallenge

class DeveloperChallengeTests: XCTestCase {
    
    private var dataService: DataService!
    private var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        // Initialise the DataService singleton class that is used to save the data to the database and wipe the database clean.
        // Instantiate a Dispose Bag to be used by the Rx signals.
        dataService = DataServiceImp.shared
        dataService.resetDatabase()
        disposeBag = DisposeBag()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSameItemIsInsertedOnlyOnceInDatabase() {
        // This is a test to see if an array of the same articles is passed to be saved in Core Data that only one of those same articles
        // will be saved, therefore eliminating duplication.
        let reddit1: Reddit = RedditAPIModel(identifier: "abc123", author: "User1", message: "This is test 1", score: 1, date: 1503026487)
        
        let arrayOfSameReddits = [reddit1, reddit1, reddit1]
        dataService.save(arrayOfSameReddits)
            .asObservable()
            .subscribe(onNext: { [unowned self] (_) in
                let fetchedReddits = self.dataService.fetchItems()
                XCTAssertTrue(fetchedReddits.count == 1)
                XCTAssertTrue(fetchedReddits.first?.redditAuthor == "User1")
            }).disposed(by: disposeBag)
    }
    
    func testDifferentItemsAreInsertedOnlyOnceEachInDatabase() {
        // This is a test to see if an array that constains duplicate copies of two articles is passed to be saved in Core Data that only
        // one of each of them will will be saved, therefore eliminating duplication. The order is also checked by time with reddit1
        // having the later time stamp and therefore it should be in the first place.
        let reddit1: Reddit = RedditAPIModel(identifier: "abc123", author: "User1", message: "This is test 1", score: 1, date: 1503026487)
        let reddit2: Reddit = RedditAPIModel(identifier: "def456", author: "User2", message: "This is test 2", score: 2, date: 1503025262)
        
        let arrayOfSameReddits = [reddit1, reddit2, reddit1, reddit1, reddit2]
        dataService.save(arrayOfSameReddits)
            .asObservable()
            .subscribe(onNext: { [unowned self] (_) in
                let fetchedReddits = self.dataService.fetchItems()
                print("\(fetchedReddits)")
                XCTAssertTrue(fetchedReddits.count == 2)
                XCTAssertTrue(fetchedReddits.first?.redditAuthor == "User1")
                XCTAssertTrue(fetchedReddits.last?.redditAuthor == "User2")
            }).disposed(by: disposeBag)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
