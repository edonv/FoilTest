//
//  TableViewControllers.swift
//  FoilTest
//
//  Created by Edon Valdman on 6/17/20.
//  Copyright © 2020 Edon Valdman. All rights reserved.
//

import UIKit

/// The `ArticleListViewController` for the first tab. This `ViewController`
/// displays the most popular articles, by most-emailed.
class EmailedViewController: UITableViewController, ArticleListViewController {
    static let urlKey: Page = .emailed
    var diffableDataSource: ArticleDataSource!
    var spinner = UIActivityIndicatorView(style: .large)
    
    /// Calls the `setUp()` function defined in `ArticleListViewController`.
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    /// Calls the protocol's `didEndDisplaying(cell:)` function,
    /// casting the given cell to `ArticleTableViewCell`.
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.didEndDisplaying(cell: cell as! ArticleTableViewCell)
    }
    
    /// Uses the `diffableDataSource` to get the item identifier for the given `indexPath`,
    /// which is then passed to the protocol's `didSelectCell(with:)` function.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let article = self.diffableDataSource.itemIdentifier(for: indexPath) else { return }
        self.didSelectCell(with: article)
    }
}

/// The `ArticleListViewController` for the second tab. This `ViewController`
/// displays the most popular articles, by most-shared.
class SharedViewController: UITableViewController, ArticleListViewController {
    static let urlKey: Page = .shared
    var diffableDataSource: ArticleDataSource!
    var spinner = UIActivityIndicatorView(style: .large)
    
    /// Calls the `setUp()` function defined in `ArticleListViewController`.
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    /// Calls the protocol's `didEndDisplaying(cell:)` function,
    /// casting the given cell to `ArticleTableViewCell`.
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.didEndDisplaying(cell: cell as! ArticleTableViewCell)
    }
    
    /// Uses the `diffableDataSource` to get the item identifier for the given `indexPath`,
    /// which is then passed to the protocol's `didSelectCell(with:)` function.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let article = self.diffableDataSource.itemIdentifier(for: indexPath) else { return }
        self.didSelectCell(with: article)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}

/// The `ArticleListViewController` for the third tab. This `ViewController`
/// displays the most popular articles, by most-viewed.
class ViewedViewController: UITableViewController, ArticleListViewController {
    static let urlKey: Page = .viewed
    var diffableDataSource: ArticleDataSource!
    var spinner = UIActivityIndicatorView(style: .large)
    
    /// Calls the `setUp()` function defined in `ArticleListViewController`.
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    /// Calls the protocol's `didEndDisplaying(cell:)` function,
    /// casting the given cell to `ArticleTableViewCell`.
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.didEndDisplaying(cell: cell as! ArticleTableViewCell)
    }
    
    /// Uses the `diffableDataSource` to get the item identifier for the given `indexPath`,
    /// which is then passed to the protocol's `didSelectCell(with:)` function.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let article = self.diffableDataSource.itemIdentifier(for: indexPath) else { return }
        self.didSelectCell(with: article)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
