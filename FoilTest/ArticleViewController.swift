//
//  ArticleViewController.swift
//  FoilTest
//
//  Created by Edon Valdman on 6/20/20.
//  Copyright © 2020 Edon Valdman. All rights reserved.
//

import UIKit

/// The `ViewController` that displays the `NYTArticle` itself.
class ArticleViewController: UIViewController {
    
    /// This view contains the imgView and copyrightLabel.
    /// This is placed in a `UIStackView` to allow for
    /// easy hiding when not needed.
    @IBOutlet var imgCaptionContainer: UIView!
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var copyrightLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var abstractLabel: UILabel!
    @IBOutlet var bylineLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var bodyLabel: UILabel!
    
    var article: NYTArticle!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setViews()
        self.navigationItem.largeTitleDisplayMode = .never
    }
    
    /// Fills in the `View`s of the page. `bodyLabel` is left as is
    /// because the API doesn't provide the body text of the article.
    func setViews() {
        if let img = article.media.first,
            let data = article.imgData {
            imgView.image = UIImage(data: data)
            copyrightLabel.text = img.copyright
        } else {
            imgCaptionContainer.isHidden = true
        }
        
        titleLabel.text = article.title
        titleLabel.font = UIFont.systemFont(ofSize: UIFont.scaledSize(for: .largeTitle), weight: .bold, withDesign: .serif)
        
        abstractLabel.text = article.abstract
        bylineLabel.text = article.byline
        dateLabel.text = SessionData.prettyFormatter.string(from: article.publishedDate)
        
        bodyLabel.font = UIFont.systemFont(ofSize: UIFont.scaledSize(for: .body), weight: .regular, withDesign: .serif)
    }
}
