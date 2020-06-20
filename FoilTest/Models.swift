//
//  Models.swift
//  FoilTest
//
//  Created by Edon Valdman on 6/17/20.
//  Copyright © 2020 Edon Valdman. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

/// Corresponds with the JSON response from the API. The response is converted
/// into an instance of this class via Swift's `Decodable` protocol.
class NYTResponse: Decodable {
    var status: String
    var copyright: String
    var numResults: Int
    var results: [NYTArticle]
    
    init(status: String, copyright: String, numResults: Int, results: [NYTArticle]) {
        self.status = status
        self.copyright = copyright
        self.numResults = numResults
        self.results = results
    }
    
    /// These are used to map properties of the class to entries in the JSON response.
    enum CodingKeys: String, CodingKey {
        case status, results, copyright
        case numResults = "num_results"
    }
}

/// Corresponds with article objects in the JSON response from the API.
class NYTArticle: Decodable {
    var url: URL
    var id: Int
    var source: String
    var publishedDate: Date
    var title: String
    var abstract: String
    var section: String
    var byline: String
    var media: [NYTMedia]
    
    init(url: URL, id: Int, source: String, publishedDate: Date, title: String, abstract: String, section: String, byline: String, media: [NYTMedia]) {
        self.url = url
        self.id = id
        self.source = source
        self.publishedDate = publishedDate
        self.title = title
        self.abstract = abstract
        self.section = section
        self.byline = byline
        self.media = media
    }
    
    /// These are used to map properties of the class to entries in the JSON response.
    enum CodingKeys: String, CodingKey {
        case url, id, source
        case publishedDate = "published_date"
        case title, abstract, section, byline, media
    }
    
    /// Contains the data of the article's image if it's been loaded yet.
    var imgData: Data? = nil
    
    /// The `NSAttributeString` attributes used for the title portion of `titleLabel`
    /// in `ArticleTableViewCell`.
    lazy var titleAttributes: [NSAttributedString.Key: Any] = {
        [NSAttributedString.Key.font: UIFont.systemFont(ofSize: UIFont.scaledSize(for: .body), weight: .bold, withDesign: .serif)]
    }()
    /// The `NSAttributeString` attributes used for the abstract portion of `titleLabel`
    /// in `ArticleTableViewCell`.
    lazy var abstractAttributes: [NSAttributedString.Key: Any] = {
        [NSAttributedString.Key.font: UIFont.systemFont(ofSize: UIFont.scaledSize(for: .body), weight: .regular, withDesign: .serif)]
    }()
    /// Merges the title and abstract into one `NSAttributedString` using the above attributes.
    var summaryString: NSAttributedString {
        let s1 = NSMutableAttributedString(string: "\(self.title)  ")
        s1.addAttributes(titleAttributes, range: NSRange(0..<s1.length))
        
        let s2 = NSMutableAttributedString(string: self.abstract)
        s2.addAttributes(abstractAttributes, range: NSRange(0..<s2.length))
        s1.append(s2)
        return s1
    }
}

extension NYTArticle: Hashable {
    static func == (lhs: NYTArticle, rhs: NYTArticle) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

/// Corresponds with media objects in the JSON response from the API.
struct NYTMedia: Decodable, Hashable {
    var caption: String
    var copyright: String
    var metadata: [Metadata]
    
    enum CodingKeys: String, CodingKey {
        case caption, copyright, metadata = "media-metadata"
    }
    
    /// Corresponds with metadata objects in the JSON response from the API.
    struct Metadata: Decodable, Hashable {
        var url: URL
        var format: Format
        var height: Int
        var width: Int
        
        /// Corresponds with metadata format constants in the JSON response from the API.
        enum Format: String, Decodable {
            case thumbnail = "Standard Thumbnail"
            case medium210 = "mediumThreeByTwo210"
            case medium440 = "mediumThreeByTwo440"
        }
    }
}

/// This doesn't have much use, but `UITableViewDiffableDataSource`
/// requires a Hashable type for the sections, and there has to be
/// at least one section.
enum Section: Hashable {
    case main
}

/// The type used for a `UITableViewDiffableDataSource` where the section
/// type is `Section` and the item type is `NYTArticle`.
typealias ArticleDataSource = UITableViewDiffableDataSource<Section, NYTArticle>
/// The type used for a `NSDiffableDataSourceSnapshot` where the section
/// type is `Section` and the item type is `NYTArticle`.
typealias ArticleSnapshot = NSDiffableDataSourceSnapshot<Section, NYTArticle>
