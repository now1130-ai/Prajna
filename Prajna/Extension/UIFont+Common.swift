//
//  UIFont+Common.swift
//  UU Wallet
//
//  Created by Dev1 on 2024.03.13.
//

import Foundation
import UIKit

extension UIFont {
    enum FontType {
        case MSB, MB, PR, PSB, PM, PL, Default
    }

    class func creat(type: FontType, size: CGFloat) -> UIFont {
        switch type {
        case .MSB:
            return UIFont(name: "Montserrat-SemiBold", size: size) ?? UIFont()
        case .MB:
            return UIFont(name: "Montserrat-Bold", size: size) ?? UIFont()
        case .PR:
            return UIFont(name: "Poppins-Regular", size: size) ?? UIFont()
        case .PSB:
            return UIFont(name: "Poppins-SemiBold", size: size) ?? UIFont()
        case .PM:
            return UIFont(name: "Poppins-Medium", size: size) ?? UIFont()
        case .PL:
            return UIFont(name: "Poppins-Light", size: size) ?? UIFont()
        default:
            return UIFont(name: "Poppins-Regular", size: size) ?? UIFont()
        }
    }
}
