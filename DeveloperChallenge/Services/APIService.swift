
//
//  APIService.swift
//  DeveloperChallenge
//
//  Created by Robert Bernardini on 4/16/19.
//  Copyright © 2019 Qantas Assure. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SSZipArchive

// API Service Protocol
protocol APIService {
    func fetchData(at url: URL) -> Single<String?>
    func cancelDownload()
}

// Concrete class that implements the API Service protocol.
// This class is used to perform any API service functions.
// The currently running download task can also be cancelled by the user.
class APIServiceImp: NSObject, APIService {
    
    static let shared = APIServiceImp()
    private var downloadTask: URLSessionDownloadTask?
    
    private override init() {
        super.init()
    }
    
    func fetchData(at url: URL) -> Single<String?> {
        return Single<String?>.create(subscribe: { [unowned self] (event) in
            
            // A completion is used to obtain the Reddit articles. By using a completion the URLSessionDownloadDelegate
            // is overridden and therefore cannot be used to update the progress of the download. This functionality of
            // overriding a delegate by using a completion instead of allowing the ability to use both has been decided by Apple.
            // The delegate functions could have been used in place of the completion but in order to keep the code concise,
            // clean and to use RxSwift more effectively I decided to stay with the completion and to update the progress
            // of the Reddit article downloading and saving in the Repository.
            let task = URLSession.shared.downloadTask(with: url, completionHandler: { (location, response, error) in
                if let downloadError = error as NSError?, downloadError.code != NSURLErrorCancelled {
                    event(.error(downloadError))
                    return
                }
                return event(.success(location?.path))
            })
            task.resume()
            self.downloadTask = task
            
            return Disposables.create {
                task.cancel()
            }
        })
    }
    
    func cancelDownload() {
        guard let task = downloadTask else {
            return
        }
        task.cancel()
    }
}
