//
//  NotificationManager.swift
//  UU Wallet
//
//  Created by Dev1 on 2024/4/10.
//

import Foundation

typealias NotificationHandler = (Notification) -> Void

/// 通知定义
extension Notification.Name {
    static let test = Notification.Name("test")

    /// 用户信息更新啦（头像 昵称 默认货币）
    static let updateUserData = Notification.Name("updateUserData")

    /// 默认货币更新
    static let updateDefaultFiat = Notification.Name("updateDefaultFiat")

    /// 启动完成再增加首页请求(更新弹窗)
    static let startUpHomeRequest = Notification.Name("startUpHomeRequest")
    
    // 触发i18n切换
    static let onI18nRefresh = Notification.Name("onI18nRefresh")
    
    // 触发语言切换
    static let onLangChanged = Notification.Name("onLangChanged")
    
    // 订单更新后刷新相关的view
    static let updateOrder = Notification.Name("updateOrder")
    
    // 换汇成功
    static let convertSuccess = Notification.Name("convertSuccess")
    
    // 9d登录成功跳转
    static let nineDLoginSuccess = Notification.Name("nineDLoginSuccess")
    
    static let nineDConvertIntErrorSuccess = Notification.Name("nineDConvertIntErrorSuccess")
    /// h5事件通知隐藏底部tabbar，用于预付卡h5跳转子页面
    static let hideBottomTabs = Notification.Name("hide_app_bottom_tabs")
    
    /// 调整充提确认弹窗高度
    static let updatePopHeight = Notification.Name("updatePopHeight")
    /// 关闭充提确认弹窗
    static let dismissToAsset = Notification.Name("dismissToAsset")
    
    /// 跳转充提订单详情
    static let showOrder = Notification.Name("showOrder")
    
    /// 跳转手动渠道充提确认
    static let showResultManual = Notification.Name("showResultManual")
    
    static let submiting = Notification.Name("submiting")
    
    /// 订单提交错误单独适配
    static let orderSubmitError = Notification.Name("orderSubmitError")
    
    /// 订单多次提交错误单独适配
    static let orderDepositErrorOrderUndoTooMany = Notification.Name("orderDepositErrorOrderUndoTooMany")
    
    /// 指定币种换汇
//    static let convert = Notification.Name("convert")
    
    /// 网络可用通知
    static let getReachability = Notification.Name("getReachability")
    
    /// 找回账号去登录
    static let retrieveAccount = Notification.Name("RetrieveAccount")
    
    /// 预付卡设置手机号/邮箱
    static let cardSetup = Notification.Name("cardSetup")
    
    /// 预付卡状态更新
    static let cardUpdate = Notification.Name("cardUpdate")
    
    /// 预付卡选卡页，已开卡显示改卡
    static let cardSelect = Notification.Name("cardSelect")
    
    /// 预付卡激活设置成功后，直接弹窗
    static let cardActivateSuccess = Notification.Name("cardActivateSuccess")
    
    /// 首页关闭本地计价选择
    static let closeLocalFiat = Notification.Name("closeLocalFiat")
    
    /// 切换主页时清空兑换当前选中
    static let clearConvertDefault = Notification.Name("clearConvertDefault")
    
    /// 选中兑换刷新主页
    static let reloadConvertDataSource = Notification.Name("reloadConvertDataSource")
    
    /// 通知首页获取通知
    static let getHomePageAnnouncement = Notification.Name("getHomePageAnnouncement")
    
    /// 切换登录页面通知(更新弹窗)
    static let startLoginRequest = Notification.Name("startLoginRequest")
    
    /// 兑换页面每次出现是否需要刷新
    static let convertNeedRefresh = Notification.Name("convertNeedRefresh")
}

class NotificationUtil {
    static func addObserver(forName name: Notification.Name, object: Any? = nil, queue: OperationQueue? = nil, using block: @escaping (Notification) -> Void) {
        NotificationCenter.default.addObserver(forName: name, object: object, queue: queue, using: block)
    }

    static func post(name: Notification.Name, object: Any? = nil, userInfo: [AnyHashable: Any]? = nil) {
        NotificationCenter.default.post(name: name, object: object, userInfo: userInfo)
    }
    
    static func remove(observer: Any, name: Notification.Name, object: Any? = nil) {
        NotificationCenter.default.removeObserver(observer, name: name, object: object)
    }
}
