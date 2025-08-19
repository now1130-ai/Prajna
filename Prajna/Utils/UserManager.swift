//
//  UserManager.swift
//  UU Wallet
//
//  Created by Dev1 on 2024/4/1.
//

import UIKit

class UserManager: NSObject {
    @objc static let shared = UserManager()
    private let decodeer = JSONDecoder()
    private let encoder = JSONEncoder()
    private let filemanger = FileManager.default

    let userFilePath: String = NSHomeDirectory() + "/Documents/usermodel"
    var userFileURL: URL {
        return URL(fileURLWithPath: userFilePath)
    }

    let thirdPartyFilePath: String = NSHomeDirectory() + "/Documents/threePartyModel"
    var thirdPartyFileURL: URL {
        return URL(fileURLWithPath: thirdPartyFilePath)
    }

    /// 独立存储用户Token
    /// - Parameter token: token description
    func saveToken(token: String) {
        UserDefaults.standard.set(token, forKey: kAuthToken)
    }

    func clearToken() {
        UserDefaults.standard.removeObject(forKey: kAuthToken)
        UserDefaults.standard.set(false, forKey: kIsFirstHomeAnnounce)
    }
    
//    /// 记录上次登录类型
//    /// - Parameter type: 登录类型
//    func saveLoginTypeRecord(type: AccountTypeEnum?) {
//        if type == nil {
//            return
//        }
//        UserDefaults.standard.removeObject(forKey: kLoginTypeRecord)
//        UserDefaults.standard.set(type?.rawValue, forKey: kLoginTypeRecord)
//    }
//    func getLoginTypeRecord() -> AccountTypeEnum {
//        let type = UserDefaults.standard.integer(forKey: kLoginTypeRecord)
//        return type <= 0 ? .id : AccountTypeEnum.fromInt(data: type)
//    }
    

    @objc func getToken() -> String {
        let token = UserDefaults.standard.string(forKey: kAuthToken)
        return isEmptyStr(token) ? "" : token!
    }

    /// 对登录注册区号进行缓存
    func saveAreaNo(areaNo: String) {
        UserDefaults.standard.set(areaNo, forKey: kLoginAreaNo)
    }

    func getAreaNo() -> String {
        let areaNo = UserDefaults.standard.string(forKey: kLoginAreaNo)
        return isEmptyStr(areaNo) ? "" : areaNo!
    }
    
    func initUser(){
        
        let needyg = UserManager.shared.getNeedyg()
        
        if needyg == "0" {
            ConfigManager.manager.setLoyal()
            //JLog("check result = true")
            ConfigManager.manager._noyg = true
        }else {
            ConfigManager.manager._noyg = false
        }
    }
    func getNeedyg() -> String {
        let token = UserDefaults.standard.string(forKey: kNeedyg)
//        if isLogin {
        return isEmptyStr(token) ? "" : token!
//        } else {
//            return ""
//        }
    }
    
    func saveNeedyg(needyg: Bool) {
        if needyg {
            ConfigManager.manager.needyg = "1"
        }else {
            ConfigManager.manager.needyg = "0"
        }
        
        UserDefaults.standard.set(needyg, forKey: kNeedyg)
    }
    
    /// 对google服务的fcmToken进行缓存
    func saveFCMToken(token: String) {
        UserDefaults.standard.set(token, forKey: kFcmToken)
    }

    func getFCMToken() -> String {
        let token = UserDefaults.standard.string(forKey: kFcmToken)
//        if isLogin {
        return isEmptyStr(token) ? "" : token!
//        } else {
//            return ""
//        }
    }

    /// 是否登录状态
    var isLogin: Bool {
//        let user = getUserModel()
//        if isEmptyStr(user.account) {
            return false
//        } else {
//            return true
//        }
    }
    
    /// 是否隐藏资产展示
    var isHiddenAssets: Bool {
        let hiddenAssets = UserDefaults.standard.bool(forKey: kIsHiddenAssets)
        return hiddenAssets
    }
    
    func saveAssetsState(isHidden: Bool) {
        UserDefaults.standard.set(isHidden, forKey: kIsHiddenAssets)
    }
    
    /// 用户选择本地币种缓存
    // 获取存储在 UserDefaults 中的数组，如果没有，则返回一个空数组
    func getLocalCurrencies() -> [Int] {
        if let storedArray = UserDefaults.standard.array(forKey: kLocalIntArray) as? [Int] {
            return storedArray
        } else {
            return []
        }
    }
    // 更新数组并存储到 UserDefaults 中
    private func saveLocalCurrencies(_ array: [Int]) {
        UserDefaults.standard.set(array, forKey: kLocalIntArray)
    }
    // 存储新的 Int 值
    func saveCurrencyValue(_ newValue: Int) {
        var array = getLocalCurrencies()
        // 检查数组中是否已经包含该值
        if let index = array.firstIndex(of: newValue) {
            // 如果存在，将该值移到数组的第一位
            array.remove(at: index)
            array.insert(newValue, at: 0)
        } else {
            // 如果不存在，直接将该值插入到数组的第一位
            array.insert(newValue, at: 0)
        }
        // 保存更新后的数组
        saveLocalCurrencies(array)
    }
    // 清空数组
    func clearLocalCurrencies() {
        UserDefaults.standard.removeObject(forKey: kLocalIntArray)
    }
    

//    /// 存储用户信息
//    func saveModel(_ user: UserModel) {
//        let ishave = filemanger.fileExists(atPath: userFilePath)
//        if ishave == true {
//            clearUserModel()
//        }
//        let showModel = user
//        var data = Data()
//        data = try! encoder.encode(showModel)
//        try! data.write(to: userFileURL, options: .atomic)
//    }
//
//    /// 适配提审账号
//    func loginyg(userModel: UserModel){
//        var needyg = false
////        #if DEBUG
////            if userModel.account == "rainytest1" {
////                needyg = true
////            }
////        #elseif RELEASE
////            if userModel.account == "cyrelmail" {
////                needyg = true
////            }
////        #elseif STAGE
////            if userModel.account == "cystg08"{ // || userModel.account == "DD100"
////                needyg = true
////            }
////        #elseif PROD
////        if userModel.account == "rainytest1" {
////            needyg = true
////        }
////        #else
////            
////        #endif
//        
//        needyg = userModel.account == "rainytest1"
//        
//        saveNeedyg(needyg: needyg)
//    }
//    
//    /// 获取用户信息
//    func getUserModel() -> UserModel {
//        let user = UserModel()
//        guard let data = filemanger.contents(atPath: userFilePath) else { return user }
//        let showModel = try! decodeer.decode(UserModel.self, from: data)
//        return showModel
//    }
    
    /// 退出登录,清空信息
    func logOut() {
        clearUserModel()
//        clearThirdPartyModel()
        clearToken()
        clearLocalCurrencies()
        saveAssetsState(isHidden: false)
        // 用户未登录,重置生物识别状态并设置登录页面为根视图控制器
        UserDefaults.saveBiometricState(isBiometric: false)
//        CardUtil.logOut()
//        SettingApi.manager.firebaseTokenConfig(token: UserManager.shared.getFCMToken()) { _ in }
    }
    /// 清空用户信息
    func clearUserModel() {
        let ishave = filemanger.fileExists(atPath: userFilePath)
        if ishave == true {
            try! filemanger.removeItem(atPath: userFilePath)
        }
    }

    /// 清空用户配置信息
    func clearUserConfigInfo() {
        // 兑换-展示所有联系人
        UserDefaults.standard.removeObject(forKey: "reminderShowAll")
    }

//    /// 存储三方登录用户信息
//    func saveThirdPartyModel(_ user: NDBodyModel) {
//        let ishave = filemanger.fileExists(atPath: thirdPartyFilePath)
//        if ishave == true {
//            clearThirdPartyModel()
//        }
//        let showModel = user
//        var data = Data()
//        data = try! encoder.encode(showModel)
//        try! data.write(to: thirdPartyFileURL, options: .atomic)
//    }

//    /// 获取第三方登录用户信息
//    func getThirdPartyModel() -> NDBodyModel {
//        let user = NDBodyModel()
//        guard let data = filemanger.contents(atPath: thirdPartyFilePath) else { return user }
//        let showModel = try! decodeer.decode(NDBodyModel.self, from: data)
//        return showModel
//    }
//
//    func hasThirdParty() -> Bool{
//        let thirdPartyModel = UserManager.shared.getThirdPartyModel()
//        return !isEmptyStr(thirdPartyModel.token)
//    }
//    /// 清空第三方登录用户信息
//    func clearThirdPartyModel() {
//        GIDSignIn.sharedInstance.signOut()
//        let ishave = filemanger.fileExists(atPath: thirdPartyFilePath)
//        if ishave == true {
//            try! filemanger.removeItem(atPath: thirdPartyFilePath)
//        }
//    }
//
//    /// 开启生物验证
//    func openBiometricVeri() {
//        if UserManager.shared.isLogin && BiometricsManager.shared.isBiometricAvailable && UserDefaults.getBiometricState() {
//            let vc = UIApplication.topViewController()
//            if !(vc is VerifBiometricViewController) {
//                vc?.navigationController?.pushViewController(VerifBiometricViewController(), animated: true)
//            }
//        }
//    }
//
//    /// 是否满足2FA验证
//    /// - Returns: bool值
//    func isAvable2FAVerif() -> Bool {
//        var level = 0
//        let userModel: UserModel = UserManager.shared.getUserModel()
////        if !isEmptyStr(userModel.email) {
////            level += 1
////        }
////        if !isEmptyStr(userModel.mobile) {
////            level += 1
////        }
////        if userModel.googleConfirm == "1" {
////            level += 1
////        }
////        return level >= 2
//        if userModel.googleConfirm == "0" || (isEmptyStr(userModel.email) && isEmptyStr(userModel.mobile)) {
//            return false
//        } else {
//            return true
//        }
//    }

    
}
