//
//  Extensions.swift
//  FoilTest
//
//  Created by Edon Valdman on 6/17/20.
//  Copyright © 2020 Edon Valdman. All rights reserved.
//

import UIKit
import PromiseKit

import Kingfisher

extension KingfisherWrapper where Base: KFCrossPlatformImageView {
    /// Wraps the original Kingfisher function in a `Promise`, which allows for
    /// convenient interoperability throughout the codebase.
    func setImage(with resource: Resource?,
                  placeholder: Placeholder? = nil,
                  options: KingfisherOptionsInfo? = nil,
                  progressBlock: DownloadProgressBlock? = nil) -> Promise<RetrieveImageResult> {
        return Promise { seal in
            self.setImage(with: resource, placeholder: placeholder, options: options, progressBlock: progressBlock) { result in
                switch result {
                case .success(let v):
                    seal.fulfill(v)
                case .failure(let e):
                    seal.reject(e)
                }
            }
        }
    }
}

import Alamofire

extension DataRequest {
    /// Wraps the original Alamofire function in a `Promise`, which allows for
    /// convenient interoperability throughout the codebase.
    func responseDecodable<T: Decodable>(_ namespacer: PMKNamespacer,
                                         of type: T.Type = T.self,
                                         queue: DispatchQueue = .main,
                                         dataPreprocessor: DataPreprocessor = DecodableResponseSerializer<T>.defaultDataPreprocessor,
                                         decoder: DataDecoder = JSONDecoder(),
                                         emptyResponseCodes: Set<Int> = DecodableResponseSerializer<T>.defaultEmptyResponseCodes,
                                         emptyRequestMethods: Set<HTTPMethod> = DecodableResponseSerializer<T>.defaultEmptyRequestMethods) -> Promise<T> {
        return Promise { seal in
            self.responseDecodable(of: type, queue: queue, dataPreprocessor: dataPreprocessor, decoder: decoder, emptyResponseCodes: emptyResponseCodes, emptyRequestMethods: emptyRequestMethods) { response in
                switch response.result {
                case .success(let v):
                    seal.fulfill(v)
                case .failure(let e):
                    seal.reject(e)
                }
            }
        }
    }
}

extension UIFont {
    /// Gives a font size for a given `UIFont.TextStyle`.
    static func scaledSize(for textStyle: UIFont.TextStyle) -> CGFloat {
        return UIFont.preferredFont(forTextStyle: textStyle).pointSize
    }
    
    /// Gives an instance of `UIFont` that has the given `fontSize`, `UIFont.Weight`, and `UIFontDescriptor.SystemDesign`.
    static func systemFont(ofSize fontSize: CGFloat, weight: UIFont.Weight = .regular, withDesign design: UIFontDescriptor.SystemDesign = .default) -> UIFont {
        return UIFont(
            descriptor: UIFont.systemFont(ofSize: fontSize, weight: weight).fontDescriptor.withDesign(design)!,
            size: fontSize
        )
    }
}
