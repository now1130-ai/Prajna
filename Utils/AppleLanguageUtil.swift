//
//  AppleLanguageUtil.swift
//  UU Wallet
//
//  Created by Dev1 on 16/10/2024.
//

class AppleLanguageUtil {
    static func currentAppleLanguage() -> String? {
        return UserDefaults.standard.stringArray(forKey: kAppleLanguages)?.first
    }
    
    static func preferredLanguages() -> String? {
        return NSLocale.preferredLanguages.first
    }

    static func setAppleLanguageTo(lang: String) {
        // Get the current list
        var languages = UserDefaults.standard.stringArray(forKey: kAppleLanguages) ?? []
        // Get all locales using the specified language
        let matching = languages.filter { $0.hasPrefix(lang) }
        if matching.count > 0 {
            // Remove those entries from the list
            languages.removeAll { $0 == lang }
            // Add them back at the start of the list
            languages.insert(contentsOf: matching, at: 0)
        } else {
            // It wasn't found in the list so add it at the top
            languages.insert(lang, at: 0)
        }
        UserDefaults.standard.set(languages, forKey: kAppleLanguages)
    }
}
