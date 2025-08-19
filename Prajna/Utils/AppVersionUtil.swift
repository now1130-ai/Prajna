//
//  AppVersionUtil.swift
//  UU Wallet
//
//  Created by Dev1 on 2024/5/20.
//

import UIKit
import Foundation

class AppVersionUtil: NSObject {
    
    /// 当前本地版本
    static let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
    /// 是否需要更新操作
    /// - Parameter newVersion: 线上版本号
    /// - Returns: 是否更新
    static func checkAppVersionIsUpdate(newVersion: String) -> Bool {
        let currentVersion = currentVersion ?? ""
        // 都为空，相等，返回0
        if newVersion == "" && currentVersion == "" {
            return false
        }
        // newVersion为空，currentVersion不为空，返回-1
        if newVersion == "" && currentVersion != "" {
            return false
        }
        // currentVersion为空，newVersion不为空，返回1
        if newVersion != "" && currentVersion == "" {
            return true
        }
        if newVersion == currentVersion {
            return false
        }
        // 获取版本号字段
        let newVersionArray = newVersion.components(separatedBy: ".")
        let currentVersionArray = currentVersion.components(separatedBy: ".")
        // 取字段最大的，进行循环比较
        let bigCount = (newVersionArray.count > currentVersionArray.count) ? newVersionArray.count : currentVersionArray.count
        for i in 0 ..< bigCount {
            // 字段有值，取值；字段无值，置0。
            let value1 = (newVersionArray.count > i) ? Int(newVersionArray[i]) ?? 0 : 0
            let value2 = (currentVersionArray.count > i) ? Int(currentVersionArray[i]) ?? 0 : 0
            if value1 > value2 {
                // newVersion版本字段大于currentVersion版本字段，返回1
                return true
            } else if value1 < value2 {
                // currentVersion版本字段大于newVersion版本字段，返回-1
                return false
            }
            // 版本相等，继续循环。
        }
        // 版本号相等
        return false
    }
}

class AppVerModel: BaseHandyJSONModel {
    
    /// 商店下载地址
    var downloadStoreUrl: String = ""
    
    var downloadFtpUrl: String = ""
    
    var createTime: Int = 0
    
    /// 富文本更新文案
    var content: String = ""
    
    // 线上最新版本号
    var version: String = ""
    
    /// 1-强制更新
    var forceUpdate: Bool = false
    
    var platform: String = ""
}
