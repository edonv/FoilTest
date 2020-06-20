//
//  ArticleTableViewCell.swift
//  FoilTest
//
//  Created by Edon Valdman on 6/17/20.
//  Copyright © 2020 Edon Valdman. All rights reserved.
//

import UIKit
import Kingfisher
import PromiseKit

class ArticleTableViewCell: UITableViewCell {
    static let reuse = "articleCell"
    
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var sectionLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var copyrightLabel: UILabel!
    
    var article: NYTArticle! {
        didSet {
            commonInit()
        }
    }
    
    /// This function is called when the `article` property is set.
    /// It fills in the `View`s of the Cell.
    private func commonInit() {
        // If the article has an attached image, it gets
        // its URL at the .medium440 scale. It also sets
        // the imgView and copyrightLabel to be shown.
        if let img = article.media.first,
            let meta = img.metadata.first(where: { $0.format == .medium440 }) {
            stackView.setCustomSpacing(4, after: imgView)
            imgView.isHidden = false
            copyrightLabel.isHidden = false
            
            copyrightLabel.text = img.copyright
            
            // This asynchronously loads the image. While it's loading, it has an
            // activity indicator (spinner) to illustrate that an image is loading.
            imgView.kf.indicatorType = .activity
            if let d = self.article.imgData {
                imgView.image = UIImage(data: d)
            } else {
                imgView.kf.setImage(with: meta.url).done { i in
                    self.article.imgData = i.image.jpegData(compressionQuality: 0.8)
                }.catch { err in
                    print("Error fetching image (\(self.article.id)): \(err)")
                }
            }
        } else {
            // If there is no image, the imgView and copyrightLabel are hidden.
            // Because they're in a UIStackView, nothing layout-related needs to be set.
            imgView.isHidden = true
            copyrightLabel.isHidden = true
        }
        
        sectionLabel.text = article.section
        titleLabel.attributedText = article.summaryString
    }
        
}
