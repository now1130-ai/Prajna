//
//  LanguageManager.swift
//  UU Wallet
//
//  Created by Dev1 on 2024.03.14.
//

import UIKit
import MJRefresh

class LanguageModel: NSObject {
    /// 名称
    var name: String = ""

    /// 简写
    var abbr: String = ""

    /// 后端需要参数
    var header: String = ""
    
    /// 语言logo
    var icon: String = ""
}

enum SupportedLanguageAbbr: String {
    case en = "en"
    case zhHans = "zh-Hans"
}

/// InfoPlist
private let kAppLanguageKey = "AppPreferredLanguage"

class LanguageManager: NSObject {
    private static var bundle: Bundle = .init()
    
    static var selectedLanguageAbbr: SupportedLanguageAbbr = .en
    
    static func readSelectedLanguage() {
        let settingsLanguage = getSettingsLanguage()
        selectedLanguageAbbr = getSupportedLanguage(from: settingsLanguage)
        
        // Get the path of the language bundle
        if let path = Bundle.main.path(forResource: selectedLanguageAbbr.rawValue, ofType: "lproj") {
            bundle = Bundle(path: path)! // Create a bundle
        }
    }
    
    
    ///-----------------------------------------------------
    private static func getSettingsLanguage() -> String {
        if let appleLanguage = AppleLanguageUtil.currentAppleLanguage() {
            JLog("language init -- use appleLanguage = \(appleLanguage)")
            return appleLanguage
        }
        if let preferedLanguage = AppleLanguageUtil.preferredLanguages() {
            JLog("language init -- use preferedLanguage = \(preferedLanguage)")
            return preferedLanguage
        }
        return SupportedLanguageAbbr.en.rawValue
    }
    
    private static func getSupportedLanguage(from currentLanguage: String) -> SupportedLanguageAbbr {
        currentLanguage.hasPrefix("zh") ? .zhHans : .en
    }

    /// 当前Language
    static var languageModel: LanguageModel {
        for (_, model) in languageModelArray.enumerated() {
            if model.abbr == selectedLanguageAbbr.rawValue {
                return model
            }
        }
        let defaultModel = LanguageModel()
        defaultModel.name = "English"
        defaultModel.abbr = "en"
        defaultModel.header = "en-US"
        defaultModel.icon = "ic_language_en-US"
        return defaultModel
    }
    
    static var isUserLanguageZh: Bool {
        selectedLanguageAbbr == .zhHans
    }

    static var languageModelArray: [LanguageModel] {
        let enModel = LanguageModel()
        enModel.name = "English"
        enModel.abbr = "en"
        enModel.header = "en-US"
        enModel.icon = "ic_language_en-US"

        let zhModel = LanguageModel()
        zhModel.name = "简体中文"
        zhModel.abbr = "zh-Hans"
        zhModel.header = "zh-CN"
        zhModel.icon = "ic_language_zh-CN"

        return [enModel, zhModel]
    }

    static func changeLanguage(to newLanguageModel: LanguageModel) {
        guard let newLanguageAbbr = SupportedLanguageAbbr(rawValue: newLanguageModel.abbr),
                selectedLanguageAbbr != newLanguageAbbr else {
            return
        }
        
        JLog("changeLanguage = \(newLanguageAbbr)")
        selectedLanguageAbbr = newLanguageAbbr
        NotificationUtil.post(name: .onLangChanged)
        AppleLanguageUtil.setAppleLanguageTo(lang: newLanguageModel.header)
        
        if let path = Bundle.main.path(forResource: newLanguageAbbr.rawValue, ofType: "lproj") {
            bundle = Bundle(path: path)!
        }
    }

    static func localizedString(forKey key: String) -> String {
        return NSLocalizedString(key, tableName: "Localizable", bundle: bundle, value: "", comment: "")
    }
}

// Bundle扩展
//extension Bundle {
//    @objc func appLocalizedString(forKey key: String, value: String?, table: String?) -> String {
//        // 获取应用设置的语言
//        let language = LanguageManager.currentLanguage
//        
//        // 1. 尝试从指定语言的bundle获取
//        if let path = self.path(forResource: language, ofType: "lproj"),
//           let bundle = Bundle(path: path) {
//            return bundle.appLocalizedString(forKey: key, value: value, table: table)
//        }
//        
//        // 2. 回退到父类实现
//        return self.appLocalizedString(forKey: key, value: value, table: table)
//    }
//}
//// 通知扩展
//extension Notification.Name {
//    static let appLanguageDidChange = Notification.Name("AppLanguageDidChangeNotification")
//}
