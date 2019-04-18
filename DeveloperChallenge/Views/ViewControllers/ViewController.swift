//
//  ViewController.swift
//  DeveloperChallenge
//
//  Created by Rogerio de Paula Assis on 30/6/17.
//  Copyright © 2017 Tinybeans. All rights reserved.
//

import UIKit
import CoreData
import Foundation
import SSZipArchive

// This class is used to display the Reddit article information to the user in the table.
// It subscribes to the various View Model Rx signals so to update the view once the data
// is returned.
class ViewController: UITableViewController {

    var viewModel: ViewModel = ViewModelImp()
    
    var reddits: [RedditDisplayable] = []
    let progressView = UIProgressView(progressViewStyle: .bar)

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupDatabase()
        bind()
    }
    
    private func setup() {
        navigationItem.title = "Reddit"
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        
        progressView.backgroundColor = .gray
        progressView.progressTintColor = .red
        progressView.progress = 0
        
        setRefreshButton(false)
    }
    
    private func setupDatabase() {
        viewModel.setupDatabase()
            .asObservable()
            .subscribe(onNext: { [weak self] (reddits) in
                self?.reddits = reddits
                self?.tableView.reloadData()
        }, onError: { [weak self] (error) in
            self?.showErrorAlert(error)
        }).disposed(by: viewModel.disposeBag)
    }
    
    private func bind() {
        viewModel.refreshProgress
            .asObservable()
            .subscribe(onNext: { [weak self] (progress) in
                DispatchQueue.main.async {
                    self?.progressView.progress = progress
                }
        }).disposed(by: viewModel.disposeBag)
    }

    @objc private func refreshData() {
        setRefreshButton(true)
        tableView.tableHeaderView = progressView
        
        viewModel.refreshItems()
            .asObservable()
            .subscribe(onNext: { [weak self] (reddits) in
                self?.setRefreshButton(false)
                self?.reddits = reddits
                self?.tableView.reloadData()
                self?.tableView.tableHeaderView = nil
                
            }, onError: { [weak self] (error) in
                self?.setRefreshButton(false)
                self?.tableView.tableHeaderView = nil
                self?.showErrorAlert(error)
            }).disposed(by: viewModel.disposeBag)
    }
    
    @objc private func cancelRefresh() {
        viewModel.cancelDownload()
    }
    
    private func setRefreshButton(_ isRefreshing: Bool) {
        if isRefreshing {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(ViewController.cancelRefresh))
            return
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.refresh, target: self, action: #selector(ViewController.refreshData))
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RedditCell", for: indexPath) as? RedditTableViewCell else {
            return UITableViewCell()
        }
        cell.data = reddits[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reddits.count
    }
}

