//
//  UIColor+Common.swift
//  UU Wallet
//
//  Created by Dev1 on 2024.03.11.
//

import Foundation
import UIKit

public extension UIColor {
    
    /// 自定义颜色方法(请谨慎使用，如无必要请直接使用资源文件来建立颜色库)
    /// - Parameter hexString: hexString description
    internal convenience init(hexString: String) {
        let hexString = hexString.replacingOccurrences(of: "#", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        // if hexString.hasPrefix("#") {scanner.scanLocation = 1}
        var color: UInt64 = 0
        scanner.scanHexInt64(&color)
        let mask = 0x0000_00FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue = CGFloat(b) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
    

//    /// #030303  alp 0.65
//    class var maskColor: UIColor {
//        // return UIColor.init(hexString: "#030303").withAlphaComponent(0.2)
//        return UIColor(named: "maskColor")!
//    }
}
