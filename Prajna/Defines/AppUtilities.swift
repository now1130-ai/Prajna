//
//  AppUtilities.swift
//  UU Wallet
//
//  Created by Dev1 on 25/9/2024.
//

@_exported import SnapKit
import Foundation

let kScreenHeight = UIScreen.main.bounds.height
let kScreenWidth = UIScreen.main.bounds.width
let kStatusBarHeight = UIApplication.getStatusBarHight()
let kNavBarHeight = kStatusBarHeight + 44.0
let kIndicatorHeight = (kStatusBarHeight > 20.0 ? 34.0 : 0.0)
let kTabBarHeight = 49.0 + kIndicatorHeight
/// stackItem间距
let kStackItemSpace = 35.0
let kMinLineH = (1.0 / UIScreen.main.scale)

/// 默认间距，20.0
let kMargin = 20.0
/// 第二间距，16.0 Second
let sMargin = 16.0
/// 最小间距 8.0 Min
let mMargin = 8.0
/// 顶部间距，12.0 Top
var tMargin = 12.0
/// 圆角，8.0
let kRadius = 8.0
/// 卡片圆角，16.0
let kCardRadius = 16.0


let amountZeroStr = "0.00"
/// 按钮高度，48
let btnHeight = 48
let btnHeightRadius = 24.0
/// 输入框高度，48
let textFieldHeight = 48

/// 本地持续化存储Key
let kIsBiometric = "isBiometric"// 是否使用生物识别
let kIsShowGuide = "isShowGuide"// 是否展示过引导页面
let kAuthToken = "AuthToken"// 存储用户token
let kLoginAreaNo = "LoginAreaNo"// 存储用户最近登录手机区号
let kNeedyg = "needyg"// 是否审核账号功能阉割
let kFcmToken = "fcmToken"// 谷歌推送通知服务token
let kIsHiddenAssets = "isHiddenAssets"// 是否隐藏用户资产
let kLocalIntArray = "localIntArray"// 本地计价币种用户选中缓存记录
let kAppleLanguages = "AppleLanguages"// 本机当前支持多语言存储
let kIsFirstBiometric = "isFirstBiometric"// 是否需要首次设置生物识别
let kIsFirstLoginPwd = "isFirstLoginPwd"// 是否需要首次设置登录密码
let kIsFirstHomeAnnounce = "isFirstHomeAnnounce"// 是否登录后首次查看首页通知
let kLoginTypeRecord = "LoginTypeRecord"//上次登录类型记录
let kCardNumCheckTime = "CardNumCheckTime"// 记录上次预付卡输入密码查看时间

// 乘除符号
let kMultiplySymbol = "×"
let kDivideSymbol = "÷"

extension String {
    var localized: String {
        return LanguageManager.localizedString(forKey: self)
    }
}

func isEmptyStr(_ str: String?) -> Bool {
    guard let str = str else { return true }
    return str.isEmpty
}

func isEmptyArr<T>(_ arr: [T]?) -> Bool {
    guard let arr = arr else { return true }
    return arr.isEmpty
}

func isEmptyDict(_ dict: [String: Any]?) -> Bool {
    guard let dict = dict else { return true }
    return dict.isEmpty
}
