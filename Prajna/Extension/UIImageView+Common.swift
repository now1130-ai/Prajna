//
//  UIImageView+Common.swift
//  UU Wallet
//
//  Created by Dev1 on 2024.04.02.
//

import UIKit
import Foundation
import Kingfisher

extension UIImageView {
    func setJkfImage(url: String, placeholder: String? = nil) {
        var isUrl = false
        if let urlStr = URL(string: url) {
            if urlStr.scheme != nil && urlStr.host != nil {
                isUrl = true
            } else {
                isUrl = false
            }
        } else {
            isUrl = false
        }
        if isUrl {
            if isEmptyStr(placeholder) {
                kf.setImage(with: URL(string: url))
            } else {
                kf.setImage(with: URL(string: url), placeholder: UIImage(named: placeholder!))
            }
        } else {
            if isEmptyStr(placeholder) {
                image = UIImage(named: url)
            } else {
                image = UIImage(named: (isEmptyStr(url) ? placeholder : url)!)
            }
        }
    }
}

extension UIButton {
    func setJkfImage(url: String, placeholder: String? = nil) {
        var isUrl = false
        if let urlStr = URL(string: url) {
            if urlStr.scheme != nil && urlStr.host != nil {
                isUrl = true
            } else {
                isUrl = false
            }
        } else {
            isUrl = false
        }
        if isUrl {
            if isEmptyStr(placeholder) {
                kf.setImage(with: URL(string: url), for: .normal)
            } else {
                kf.setImage(with: URL(string: url), for: .normal, placeholder: UIImage(named: placeholder!))
            }
        } else {
            if isEmptyStr(placeholder) {
                setImage(UIImage(named: url), for: .normal)
            } else {
                setImage(UIImage(named: (isEmptyStr(url) ? placeholder : url)!), for: .normal)
            }
        }
    }
}
