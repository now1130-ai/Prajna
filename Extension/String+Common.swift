//
//  String+Common.swift
//  UU Wallet
//
//  Created by Dev1 on 2024.03.14.
//

import CoreImage.CIFilterBuiltins
import CryptoKit
import CryptoSwift
import Foundation
import SwiftyRSA
import UIKit

extension String {
    func removeSubstring(_ substring: String) -> String {
        replacingOccurrences(of: substring, with: "")
    }

    // _ string: String,
    func widthForString(font: UIFont) -> CGFloat {
        if isEmptyStr(self) {
            return 0.0
        }
        let attributes = [NSAttributedString.Key.font: font]
        let size = (self as NSString).size(withAttributes: attributes)
        return size.width
    }

    func heightForString(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let size = CGSize(width: width, height: .greatestFiniteMagnitude)
        let options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
        let attributes = [NSAttributedString.Key.font: font]
        let boundingRect = (self as NSString).boundingRect(with: size, options: options, attributes: attributes, context: nil)
        return ceil(boundingRect.height)
    }

    /// Generate QR code based on string
    /// - Returns: description
    func generateQRCode() -> UIImage? {
        if isEmpty {
            return nil
        }
        let data = self.data(using: String.Encoding.ascii)
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter!.setValue(data, forKey: "inputMessage")
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let output = filter?.outputImage?.transformed(by: transform)
        let qrCodeImage = UIImage(ciImage: output!)
        return qrCodeImage
    }

    ///  密文显示
    /// - Returns: description
    func setSecretText() -> String {
        if isEmptyStr(self) {
            return ""
        }
        if contains("@") {
            // 找到@的位置
            guard let atIndex = firstIndex(of: "@") else {
                return self // 如果找不到@，直接返回原始字符串
            }
            // 获取首字符到@之间的子字符串
            let firstPart = prefix(upTo: atIndex)
            // 获取@之后的子字符串
            let secondPart = suffix(from: atIndex)
            switch firstPart.count {
            case 0:
                return "*" + secondPart
            case 1:
                return "*" + secondPart
            case 2:
                return "**" + secondPart
            default:
                let pgNum: Int = firstPart.count / 3
                // 获取前三位和后三位的子字符串
                let prefix = firstPart.prefix(pgNum)
                let suffix = firstPart.suffix(pgNum)
                // 生成中间的*
                var middle = ""
                for _ in 0 ..< (firstPart.count - pgNum * 2) {
                    middle += "*"
                }
                // 拼接前三位、*和后三位，并返回结果
                return "\(prefix)\(middle)\(suffix)\(secondPart)"
            }
//            // 替换首字符到@之间的字符为*
//            let maskedPart = "****"
//            // 拼接首字符、*和@之后的字符串
//            let maskedEmail = prefix(1) + maskedPart + secondPart
//            return String(maskedEmail)
        } else {
            // 如果字符串长度小于等于3，则直接返回原字符串
            switch count {
            case 1:
                return "*"
            case 2:
                return "**"
            default:
                let pgNum: Int = count / 3
                // 获取前三位和后三位的子字符串
                let prefix = prefix(pgNum)
                let suffix = suffix(pgNum)
                // 生成中间的*
                var middle = ""
                for _ in 0 ..< (count - pgNum * 2) {
                    middle += "*"
                }
                // 拼接前三位、*和后三位，并返回结果
                return "\(prefix)\(middle)\(suffix)"
            }
        }
    }
    
//    * hideContact("user@example.com") // "u**r@example.com"
//    * hideContact("aa@example.com")   // "**@example.com"
//    * hideContact("a")                // "*"
//    * hideContact("aa")               // "**"
//    * hideContact("12345678901")      // "123*****901"
    
    /// 比较大小
    /// - Parameters:
    ///   - a: 前数
    ///   - b: 后数
    /// - Returns: 比较结果：1 表示 a > b，-1 表示 a < b，0 表示 a = b
    static func compareNumber(a: Any?, b: Any?) -> Int {
        let aString = (a as? String) ?? "0"
        let bString = (b as? String) ?? "0"
        let aa = NSDecimalNumber(string: aString)// ?? NSDecimalNumber(integerLiteral: 0)
        let bb = NSDecimalNumber(string: bString)// ?? NSDecimalNumber(integerLiteral: 0)
        return aa.compare(bb).rawValue
    }

    func less(b: Any?) -> Bool {
        return String.compareNumber(a:self, b: b) < 0
    }
    
    func lessEque(b: Any?) -> Bool {
        return String.compareNumber(a:self, b: b) <= 0
    }
    
    func equal(b: Any?) -> Bool {
        return String.compareNumber(a:self, b: b) == 0
    }
    
    func equalZero() -> Bool {
        return equal(b: "0")
    }
    
    func more(b: Any?) -> Bool {
        return String.compareNumber(a:self, b: b) > 0
    }
    
    func moreZero() -> Bool {
        return more(b: "0")
    }
    
    /// MD5加密
    func md5() -> String {
        if let data = data(using: .utf8) {
            let digest = Insecure.MD5.hash(data: data)
            let md5String = digest.map { String(format: "%02hhx", $0) }.joined()
            return md5String
        }
        return ""
    }

    /// add +
    /// - Parameter number: number description
    /// - Returns: description
    func add(number: String) -> String {
        if isEmpty || self == "" || number.isEmpty || number == "" {
            return "0"
        } else {
            let a = Decimal(string: self)!
            let b = Decimal(string: number)!
            let product = a + b
            return "\(product)"
        }
    }

    ///  sub -
    /// - Parameter number: number description
    /// - Returns: description
    func sub(number: String) -> String {
        if isEmpty || self == "" || number.isEmpty || number == "" {
            return "0"
        } else {
            let a = Decimal(string: self)!
            let b = Decimal(string: number)!
            let product = a - b
            return "\(product)"
        }
    }

    /// mul *
    /// - Parameter number: number description
    /// - Returns: description
    func mul(number: String,roundingMode: NSDecimalNumber.RoundingMode = .plain, scale: Int16 = 6) -> String {
        if isEmpty || self == "" || number.isEmpty || number == "" {
            return "0"
        } else {
            let a = NSDecimalNumber(string: self)
            let b = NSDecimalNumber(string: number)
            // let a = Decimal(string: self)!
            // let b = Decimal(string: number)!
            // let product = a * b
            let handler = NSDecimalNumberHandler(roundingMode: roundingMode, scale: scale, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
            let product = a.multiplying(by: b, withBehavior: handler)
            if scale == 0 {
                if "\(product)".contains(".") {
                    let array = "\(product)".components(separatedBy: ".")
                    return "\(array.first ?? "0")"
                } else {
                    return "\(product)"
                }
            } else {
                return "\(product)"
            }
        }
    }

    /// div /
    /// - Parameter number: number description
    /// - Returns: description
    func div(number: String,roundingMode: NSDecimalNumber.RoundingMode = .plain, scale: Int16 = 6) -> String {
        if isEmpty || self == "" || number.isEmpty || number == "" {
            return "0"
        } else {
            let a = NSDecimalNumber(string: self)
            let b = NSDecimalNumber(string: number)
            // let a = Decimal(string: self)!
            // let b = Decimal(string: number)!
            // let product = a / b
            let handler = NSDecimalNumberHandler(roundingMode: roundingMode, scale: scale, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
            let product = a.dividing(by: b, withBehavior: handler)
            if scale == 0 {
                if "\(product)".contains(".") {
                    let array = "\(product)".components(separatedBy: ".")
                    return "\(array.first ?? "0")"
                } else {
                    return "\(product)"
                }
            } else {
                return "\(product)"
            }
        }
    }
    
    /// 根据时间戳和格式获取时间
    /// - Parameters:
    ///   - timestamp: 时间戳
    ///   - format: 格式
    /// - Returns: description
    static func getTime(timestamp: Int, format: String) -> String {
        var timeStr = String(format: "%ld", timestamp)
        if timeStr.count > 10 {
            let index = timeStr.index(timeStr.startIndex, offsetBy: 10)
            timeStr = String(timeStr.prefix(upTo: index))
        }
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = .current
        let unitFlags: Set<Calendar.Component> = [.year, .month, .day, .weekday, .hour, .minute, .second]
        let date = Date(timeIntervalSince1970: TimeInterval(timeStr)!)
        let comps = calendar.dateComponents(unitFlags, from: date) // DateComponents

        let yy = String(format: "%ld", comps.year!)
        let MM = String(format: "%02ld", comps.month!)
        let dd = String(format: "%02ld", comps.day!)
        let HH = String(format: "%02ld", comps.hour!)
        let mm = String(format: "%02ld", comps.minute!)
        let ss = String(format: "%02ld", comps.second!)
        let ww = String(format: "%ld", comps.weekday!)

        // 替换
        var formatStr = format
        formatStr = formatStr.replacingOccurrences(of: "MMM", with: String.getMonthEnglish(month: comps.month!))
        formatStr = formatStr.replacingOccurrences(of: "www", with: String.getWeekEnglish(week: comps.weekday!))

        formatStr = formatStr.replacingOccurrences(of: "yy", with: yy)
        formatStr = formatStr.replacingOccurrences(of: "MM", with: MM)
        formatStr = formatStr.replacingOccurrences(of: "dd", with: dd)
        formatStr = formatStr.replacingOccurrences(of: "HH", with: HH)
        formatStr = formatStr.replacingOccurrences(of: "mm", with: mm)
        formatStr = formatStr.replacingOccurrences(of: "ss", with: ss)
        formatStr = formatStr.replacingOccurrences(of: "ww", with: ww)

        return formatStr
    }

    /// 根据Int获取当前月份英文
    /// - Parameter month: 月份
    /// - Returns: description
    static func getMonthEnglish(month: Int) -> String {
        switch month {
        case 1:
            return "Jan".localized
        case 2:
            return "Feb".localized
        case 3:
            return "Mar".localized
        case 4:
            return "Apr".localized
        case 5:
            return "May".localized
        case 6:
            return "June".localized
        case 7:
            return "July".localized
        case 8:
            return "Aug".localized
        case 9:
            return "Sept".localized
        case 10:
            return "Oct".localized
        case 11:
            return "Nov".localized
        case 12:
            return "Dec".localized
        default:
            return "--"
        }
    }

    /// 根据Int获取当前星期英文
    /// - Parameter week: 星期
    /// - Returns: description
    static func getWeekEnglish(week: Int) -> String {
        switch week {
        case 1:
            return "Sun".localized
        case 2:
            return "Mon".localized
        case 3:
            return "Tues".localized
        case 4:
            return "Wed".localized
        case 5:
            return "Thur".localized
        case 6:
            return "Fri".localized
        case 7:
            return "Sat".localized
        default:
            return "--"
        }
    }

    /// 获取倒计时的文本
    /// - Parameter seconds: 多少秒  1秒就传1
    /// - Returns: XXDay hh：mm：ss
    static func getCountdownString(seconds: Int) -> String {
        guard seconds > 0 else { return "0" }
        let days = seconds / (24 * 60 * 60)
        let hours = (seconds % (24 * 60 * 60)) / 3600
        let minutes = (seconds % 3600) / 60
        let secs = seconds % 60

        var timeText: String
        if days > 0 {
            let dayString = "uu.Day".localized
            timeText = "\(days) \(dayString) \(String(format: "%02d:%02d:%02d", hours, minutes, secs))"
        } else {
            timeText = String(format: "%02d:%02d:%02d", hours, minutes, secs)
        }
        return timeText
    }

    /// 传参数据加密组装
    /// - Returns: 加密后[K:K]
    static func encryptParam(param: [String: Any]) -> [String: Any] {
#if DEBUG || STAGE
        if EnvConfig.isSafeTestEnvironment {
            if !EnvConfig.useRSA() {
                return param
            }
        }
#endif

        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        // 生成随机key
        let key = String((0 ..< 32).map { _ in letters.randomElement()! })
        // key做RSA加密
        let aeskey = String.encryptRSA(jsonString: key)

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: param, options: [])
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                let data = String.encryptAESECB(plainText: jsonString, key: key)
                return ["key": aeskey, "data": data]
            } else {
                JLog("JSON 转换失败")
            }
        } catch {
            JLog("加密出错:" + error.localizedDescription)
        }
        return ["": ""]
    }

    /// 接口返回数据解密
    /// - Parameter param:返回数据
    /// - Returns:解密后数据
    static func decryptData(param: [String: Any]?) -> [String: Any]? {
#if DEBUG || STAGE
        if EnvConfig.isSafeTestEnvironment {
            if !EnvConfig.useRSA() {
                return param
            }
        }
#endif

        if isEmptyDict(param) {
            return ["": ""]
        }

        let key = param!["key"] as? String
        let data = param!["data"] as? String
        if !isEmptyStr(key), !isEmptyStr(data) {
            let originKey = String.decryptRSA(str: key!)
            let dataJsonSting = String.decryptAESECB(cipherText: data!, key: originKey)
            guard let data = dataJsonSting.data(using: .utf8) else {
                JLog("Invalid string encoding")
                return ["": ""]
            }
            do {
                // 使用 JSONSerialization 将 Data 解析为 JSON 对象
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    return json
                } else {
                    JLog("Failed to convert JSON string to dictionary")
                    return ["": ""]
                }
            } catch {
                JLog("JSON parsing error: \(error)")
                return ["": ""]
            }
        }
        return ["": ""]
    }

    /// RSA加密
    private static func encryptRSA(jsonString: String) -> String {
        do {
            let publicKey = try PublicKey(base64Encoded: EnvConfig.publicKey)
            let clear = try ClearMessage(string: jsonString, using: .utf8)
            let encrypted = try clear.encrypted(with: publicKey, padding: .PKCS1)
            //                let data = encrypted.data
            let base64String = encrypted.base64String
            return base64String

        } catch {
            JLog("加密出错:" + error.localizedDescription)
        }
        return ""
    }

    /// RSA解密
    private static func decryptRSA(str: String) -> String {
        do {
            let privateKey = try PrivateKey(base64Encoded: EnvConfig.privateKey)

            let encrypted = try EncryptedMessage(base64Encoded: str)
            let clear = try encrypted.decrypted(with: privateKey, padding: .PKCS1)

            let data = clear.data
            // let base64String = clear.base64String
            // 将 Data 解码成 UTF-8 编码的字符串
            if let decodedString = String(data: data, encoding: .utf8) {
                return decodedString
            } else {
                JLog("解码失败")
                return ""
            }
        } catch {
            JLog(error)
            return ""
        }
    }

    /// AES加密
    private static func encryptAESECB(plainText: String, key: String) -> String {
        do {
            // 将密钥转换为字节数组
            let keyBytes = Array(key.utf8)

            // 使用 ECB 模式和 PKCS7 填充创建 AES 加密器
            let aes = try AES(key: keyBytes, blockMode: ECB(), padding: .pkcs7)

            // 将明文转换为字节数组
            let plainBytes = Array(plainText.utf8)

            // 加密明文
            let encryptedBytes = try aes.encrypt(plainBytes)

            // 将加密后的字节数组转换为 Base64 编码的字符串
            let encryptedBase64 = Data(encryptedBytes).base64EncodedString()

            return encryptedBase64
        } catch {
            JLog("Encryption error: \(error)")
            return ""
        }
    }

    // AES解密
    private static func decryptAESECB(cipherText: String, key: String) -> String {
        do {
            // 转换key和iv为UTF8的字节数组

            let keyBytes = Array(key.utf8)

            // 使用Base64解码密文
            guard let encryptedBytes = Data(base64Encoded: cipherText) else {
                JLog("Failed to decode base64 cipher text")
                return ""
            }

            // 创建AES实例
            let aes = try AES(key: keyBytes, blockMode: ECB(), padding: .pkcs7)
            // 解密数据
            let decryptedBytes = try aes.decrypt(encryptedBytes.bytes)

            // 将解密后的数据转换为字符串
            let decryptedString = String(bytes: decryptedBytes, encoding: .utf8)

            return decryptedString ?? ""
        } catch {
            JLog("Decryption failed: \(error)")
            return ""
        }
    }

    /// 去除手机号的头部无效“0”字符
    /// - Returns: description
    func removeLeadingZeros() -> String {
        let numberString = isEmptyStr(self) ? "" : self
        let pattern = "^0+"
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: 0, length: numberString.utf16.count)
        let trimmedString = regex?.stringByReplacingMatches(in: numberString, options: [], range: range, withTemplate: "") ?? numberString
        return trimmedString.isEmpty ? "0" : trimmedString
    }

    /// 检查当前输入账号是否可用
    /// - Parameter account: 账号
    /// - Returns: description
    static func isAccountAvailable(account: String) -> Bool {
        if isEmptyStr(account) {
            return false
        }
        let regex = "^[a-zA-Z0-9]*$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: account) && account.count <= 11
    }
    
    /// url添加channel、version、lang的传参
    func formatUrl()->String{
        
        var urlStr = self
        if urlStr.last != "?"{
            urlStr += !urlStr.contains("?") ? "?" : "&"
        }
        
        var deviceId = UIDevice.current.identifierForVendor?.uuidString ?? ""
        var url = "\(urlStr)channel=\(EnvConfig.channel)&version=\(AppVersionUtil.currentVersion ?? "")&lang=\(LanguageManager.languageModel.header)&deviceId=\(deviceId)"
        
        let token = UserManager.shared.getToken()
        if !isEmptyStr(token){
            url += "&token=\(token)"
        }
        
        return url

    }
    
    /// 获取本地json数据
    /// - Parameter key: key description
    /// - Returns: description
    static func getLocalJsonData(with key: String) -> Any? {
        let mainBundleDirectory = Bundle.main.bundlePath
        let path = mainBundleDirectory.appending("/LocalJson.geojson")
        let url = URL(fileURLWithPath: path)
        if let data = try? Data(contentsOf: url) {
            do {
                if let dic = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
                    return dic[key]
                }
            } catch {
                print("Error parsing JSON: \(error)")
            }
        }
        return nil
    }
    
    /// 将 HTML 字符串转换为 NSAttributedString
    func html(alignment: NSTextAlignment = .center, lineSpacing: CGFloat? = 4.0) -> NSAttributedString? {
        guard let data = self.data(using: .utf8) else { return nil }
        do {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = alignment
            paragraphStyle.lineSpacing = lineSpacing ?? 4.0
            let attributedString = try NSMutableAttributedString(data: data,
                                                          options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue],
                                                          documentAttributes: nil)
            attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
            return attributedString
        } catch {
            JLog("将 HTML 字符串转换 Error: \(error)")
            return nil
        }
    }
    
    /// 间隔位置添加空格
    func addIntervalSpace(interval:Int = 4) -> String {
        // 将字符串转换为字符数组
        let characters = Array(self)
        var result: [Character] = []
        var count = 0
        
        for char in characters {
            result.append(char)
            count += 1
            if count % interval == 0 && count != characters.count {
                result.append(Character(" "))
            }
        }
        
        // 将结果数组重新组合成字符串
        return String(result)
    }
    
    func isJSON() -> Bool {
        if isEmptyStr(self) {
            return false
        }
        guard let data = self.data(using: .utf8) else {
            return false
        }
        do {
            _ = try JSONSerialization.jsonObject(with: data, options: [])
            return true
        } catch {
            print("Invalid JSON: \(error.localizedDescription)")
            return false
        }
    }
}


extension NSMutableAttributedString {
    
    /// 创建符文本
    /// - Parameters:
    ///   - iconFirst: 是否图片在前
    ///   - text: text description
    ///   - icon: icon description
    ///   - textAttributes: textAttributes description
    ///   - iconSize: iconSize description
    /// - Returns: description
    static func createAttributed(iconFirst: Bool, text:String, icon:String, textAttributes:[NSAttributedString.Key: Any]? = nil, iconSize:CGSize? = nil) -> NSMutableAttributedString {
        let attributedText = NSMutableAttributedString(string: text, attributes: textAttributes)
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: icon)
        if iconSize != nil {// 调整图片大小
            //attachment.bounds = CGRect(x: 0, y: -3.0, width: iconSize!.width, height: iconSize!.height)
            attachment.bounds = CGRect(x: 0, y: 6 - iconSize!.height/2.0, width: iconSize!.width, height: iconSize!.height)
        }
        let imageAttachment = NSAttributedString(attachment: attachment)
        // 选择图片在前还是后
        if iconFirst {
            let result = NSMutableAttributedString()
            result.append(imageAttachment)
            result.append(NSAttributedString(string: " ")) // 添加空格
            result.append(attributedText)
            return result
        } else {
            let result = NSMutableAttributedString()
            result.append(attributedText)
            result.append(NSAttributedString(string: " ")) // 添加空格
            result.append(imageAttachment)
            return result
        }
    }
}
