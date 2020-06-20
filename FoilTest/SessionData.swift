//
//  SessionData.swift
//  FoilTest
//
//  Created by Edon Valdman on 6/17/20.
//  Copyright © 2020 Edon Valdman. All rights reserved.
//

import Foundation
import PromiseKit
import Alamofire

/// This class contains a singleton that holds the `NYTResponse`s for all tabs.
final class SessionData {
    static let shared = SessionData()
    
    var responses: [Page: NYTResponse]
    
    /// A `JSONDecoder` used by `Alamofire` to convert the
    /// API JSON objects into Swift objects. This uses a specific
    /// date format to turn the dates into Swift `Date` objects.
    static let decoder: JSONDecoder = {
        let d = JSONDecoder()
        d.dateDecodingStrategy = .formatted(isoFormatter)
        return d
    }()
    /// The `DateFormatter` used to decode the JSON dates.
    static let isoFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()
    /// The `DateFormatter` used to display the `Date` objects nicely.
    static let prettyFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "MMMM d, yyyy"
        return f
    }()
    
    private init() {
        self.responses = [:]
    }
}
