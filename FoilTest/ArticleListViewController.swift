//
//  ArticleListViewController.swift
//  FoilTest
//
//  Created by Edon Valdman on 6/20/20.
//  Copyright © 2020 Edon Valdman. All rights reserved.
//

import UIKit
import PromiseKit
import Alamofire

/// This enum has one case per tab/page. The API URL
/// needed for each page is completed using its rawValue.
enum Page: String, Hashable {
    case emailed
    case shared
    case viewed
}

/// Because all three tabs are effectively the same, it made sense
/// to make a single protocol that contained all the similarities.
/// The protocol contains the pieces that are different for each
/// page, while the extension allows for more detailed functionality
/// that is identical for each page to be defined. As much identical
/// code as possible has been placed in the extension, rather than
/// copy-pasted into each individual page's class definition.
protocol ArticleListViewController: UITableViewController {
    /// Defines each individual page's identifier for the API URL.
    static var urlKey: Page { get }
    /// The spinner displayed while loading the page.
    var spinner: UIActivityIndicatorView { get }
    /// Each page's `TableView` DataSource.
    var diffableDataSource: ArticleDataSource! { get set }
}

extension ArticleListViewController {
    /// This variable uses each individual page's unique `urlKey` to compose its URL for the API.
    static var apiURL: String {
        "https://api.nytimes.com/svc/mostpopular/v2/\(urlKey.rawValue)/7.json?api-key=dylOnQnYUzEF1B9MTYYHM0MyffMPBZRi"
    }
    
    /// Calls the two functions necessary to set up each `ViewController`.
    func setUp() {
        setUpSpinnerView()
        setUpTableView()
    }
    
    /// Sets properties related to the `UIActivityIndicatorView`.
    func setUpSpinnerView() {
        spinner.hidesWhenStopped = true
        tableView.backgroundView = spinner
        spinner.startAnimating()
    }
    
    /// Sets properties related to the `UITableView`. Allows for vertically-flexible
    /// `UITableViewCell`s, defines the `UITableViewDiffableDataSource`, and calls
    /// `initSnapshot()` to start the loading process.
    func setUpTableView() {
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 280
        self.tableView.register(UINib(nibName: "ArticleTableViewCell", bundle: nil), forCellReuseIdentifier: ArticleTableViewCell.reuse)
        
        self.diffableDataSource = ArticleDataSource(tableView: tableView, cellProvider: { (tv, ip, article) -> UITableViewCell? in
            let cell = tv.dequeueReusableCell(withIdentifier: ArticleTableViewCell.reuse, for: ip) as! ArticleTableViewCell
            cell.article = article
            return cell
        })
        
        self.diffableDataSource.defaultRowAnimation = .fade
        initSnapshot()
    }
    
    /// Creates a `NSDiffableDataSourceSnapshot` and asynchronously loads
    /// `NYTArticle`s from via the `apiURL` and `Alamofire`.
    func initSnapshot() {
        var snapshot = diffableDataSource.snapshot()
        
        firstly { () -> Promise<NYTResponse> in
            if let resp = SessionData.shared.responses[Self.urlKey] {
                return .value(resp)
            } else {
                return AF.request(Self.apiURL)
                    .validate()
                    .validate(contentType: ["application/json"])
                    .responseDecodable(.promise, of: NYTResponse.self, decoder: SessionData.decoder)
            }
        // This uses a .then statement instead of .done because that way,
        // it waits until the after and .done statements finish
        }.then { resp in
            // This step adds an extra 0.75 seconds of waiting time.
            // This is so the screen doesn't flicker if the load time is really fast
            after(seconds: 0.75).done {
                SessionData.shared.responses[Self.urlKey] = resp
                snapshot.appendSections([.main])
                snapshot.appendItems(resp.results, toSection: .main)
                self.diffableDataSource.apply(snapshot)
            }
        // .ensure runs whether the Promise continues successfully or it fails.
        }.ensure {
            self.spinner.stopAnimating()
        }.catch { err in
            print("Error loading emailed articles: \(err)")
        }
    }
    
    /// This function is called from `tableView(_:didEndDisplaying:forRowAt:)` for each page.
    /// This tells`Kingfisher` to stop downloading an image for a cell that has left the screen.
    /// If a user is scrolling through a page very quickly, an error might occur if a cell was
    /// still downloading an image. This stops those downloads if they're there.
    /// - Parameter cell: The cell that has disappeared.
    func didEndDisplaying(cell: ArticleTableViewCell) {
        cell.imgView.kf.cancelDownloadTask()
    }
    
    /// This function is called from `tableView(_:didSelectRowAt:)` for each page. This
    /// tells the `ViewController` to navigate to that `NYTArticle`'s `ArticleViewController`
    /// on cell selection.
    /// - Parameter article: The `NYTArticle` of the cell selected.
    func didSelectCell(with article: NYTArticle) {
        let articleVC = self.storyboard!.instantiateViewController(withIdentifier: "articlePage") as! ArticleViewController
        articleVC.article = article
        self.show(articleVC, sender: self)
    }
}
