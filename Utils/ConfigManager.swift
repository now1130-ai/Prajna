//
//  Config.swift
//  UU Wallet
//
//  Created by Dev1 on 26/9/2024.
//

import Foundation

class ConfigModel: BaseHandyJSONModel, Codable {
    var aboutUs: String? = ""
    var contactUs: String? = ""
    var privateProtocol: String? = ""
    var termsuse: String? = ""
    var systemAnnouncement: String? = ""
    var faqurl: String? = ""
    /// 预付卡h5
    var paycardUrl: String? = ""
    
    /// 三方登录地址
    var jdFastLogin: String? = ""
    var partnerCode: String? = ""
    
    /// tg token
    var tgBotToken: String? = ""
    
    /// 代理邀请
    var agenth5Url: String? = ""
    
    /// 代理邀请是否开启，开启则显示相关入口
    var agentSwitch: Bool? = false
    /// 代理邀请的奖励币种
    var agentRewardCoin: String? = ""
    
    /// 代理邀请的奖励
    var agentRewardAmount: Int = 0
    
    /// 邀请banner调整为跳该h5链接
    var agentTaskLink: String? = ""
    
    /// faq跳转地址
    var faqDetailUrl: String? = ""
    
    /// 官方账号验证地址
    var verifyUrl: String? = ""
    
    /// 审核开关相关字段
    /// 后段配置是否需要阉割，0为不需要，1和其他情况为需要
    /// 写成拼音是为了混淆，不让苹果审核员通过代码静态分析看懂作用
    var needyg: String?
    
    /// 免费开卡link
    var freeOpenCardLink: String = ""
    
    /// 新人任务link
    var newUserTaskLink: String = ""
    
    /// 邀请首页
    var inviteHomePageLink: String = ""
    
    /// 生活服务
    var liveServiceLink: String = ""
    
    /// 安全学堂
    var safetyAcademyLink: String = ""
    
    var checkFaqUrl: String = ""
    
    /// 黑U检测地址
    var blkUrl: String = ""
    
    /// 域名
    func host()->String{
        return aboutUs?.components(separatedBy: "about").first ?? ""
    }
    
    /// 订单地址
    func order()->String{
        return host()+"orders"
    }
    
    /// 滑块地址
    func captcha()->String{
        return host()+"captcha-app-embedding"
    }
}

typealias Config = ConfigManager
class ConfigManager: NSObject {
    static let manager = ConfigManager()
    private let decodeer = JSONDecoder()
    private let encoder = JSONEncoder()
    private let filemanger = FileManager.default
    let configFilePath: String = NSHomeDirectory() + "/Documents/config"
    var configFileUrl: URL {
        return URL(fileURLWithPath: configFilePath)
    }

//    /// 从服务器拉取配置-并保存本地
//    func getConfigService(success: ((ConfigModel?) -> Void)? = nil) {
//        SettingApi.manager.getConfig { [weak self] data in
//            guard let dataDic = data as? [String: Any] else { return }
//            if isEmptyDict(dataDic) {
//                return
//            }
//            guard let model = BaseJsonUtil.dictionaryToModel(dataDic, ConfigModel.self) as? ConfigModel else {
//                return
//            }
//            self?.saveConfigModel(model)
//            self?.needyg = model.needyg ?? ""
//            if success != nil {
//                success!(model)
//            }
//        } fail: { _, _ in
//            if success != nil {
//                success!(nil)
//            }
//        }
//    }

//    /// 从本地获取配置信息 - 如果本地没有就去服务器获取
//    func getConfigLocal(success: ((ConfigModel?) -> Void)?) {
//        guard let data = filemanger.contents(atPath: configFilePath) else {
//            getConfigService(success: success)
//            return
//        }
//        
//        if let model = try? decodeer.decode(ConfigModel.self, from: data), success != nil {
//            success!(model)
//        }
//    }

    /// 存储
    private func saveConfigModel(_ config: ConfigModel) {
        let ishave = filemanger.fileExists(atPath: configFilePath)
        if ishave == true {
            clearConfigModel()
        }
        let showModel = config
        var data = Data()
        data = try! encoder.encode(showModel)
        try! data.write(to: configFileUrl, options: .atomic)
    }

    /// 清除
    private func clearConfigModel() {
        let ishave = filemanger.fileExists(atPath: configFilePath)
        if ishave == true {
            try! filemanger.removeItem(atPath: configFilePath)
        }
    }
    
    static var isyg: Bool {
        !noyg
    }
    
    /// true:常规版本  false:审核版本
    static var noyg: Bool {
//        return ConfigManager.manager.noyg
        
        let needyg = UserManager.shared.getNeedyg()
        
        if needyg == "1" || needyg == "" {
            // AppStore正在审核，不展示正式版本
            //JLog("check result = false (needyg)")
            ConfigManager.manager._noyg = false
            return false
        }
        
        if needyg == "0" {
            ConfigManager.manager.setLoyal()
            //JLog("check result = true")
            ConfigManager.manager._noyg = true
            return true
        }
        
        ConfigManager.manager._noyg = false
        return false
    }
    
    static var noygh: Bool {
        JLog("noygh: \(!noyg)")
        return !noyg
    }
    
//    let remoteConfig = RemoteConfig.remoteConfig()
    
    override init() {
        super.init()
//        remoteConfig.addOnConfigUpdateListener { configUpdate, error in
//            if let error {
//                JLog("Error listening for config updates: \(error)")
//                return
//            }
//            
//            guard let configUpdate else {
//                JLog("No updates")
//                return
//            }
//            JLog("Updated keys: \(configUpdate.updatedKeys)")
//            
//            self.remoteConfig.activate { changed, error in
//                guard error == nil else {
//                    JLog(error)
//                    return
//                }
//                JLog(changed)
//            }
//        }
    }
    
    var _noyg: Bool?
    
    var noyg: Bool {
        if let _noyg {
            return _noyg
        }
        JLog("needyg:\(needyg)")
        if needyg == "0" {
            setLoyal()
            //JLog("check result = true")
            _noyg = true
            return true
        }
        
        if needyg == "1" || needyg == "" {
            // AppStore正在审核，不展示正式版本
            //JLog("check result = false (needyg)")
            _noyg = false
            return false
        }
        
//#if DEBUG || STAGE
//        // 本地调试限制版
//        if isForceYangeForDebug() {
//            _noyg = false
//            JLog("check (debug force switcher) result = true")
//            return false
//        }
//        // 属于内部DEBUG/STAGE/RELEASE环境
//        if EnvConfig.isSafeTestEnvironment {
//            _noyg = true
//            JLog("check (isSafeTestEnvironment) result = true")
//            return true
//        }
//#endif
//        
//        // 属于存量用户，已经加载过正式版本
//        if isLoyal() {
//            _noyg = true
//            JLog("check (isLoyalUser) result = true")
//            return true
//        }
//        
//        // 这段为无关填充代码，暂时可忽略
//        remoteConfig.fetch { (status, error) -> Void in
//          if status == .success {
//              let foo = self.remoteConfig.configValue(forKey: "FirstTestMessage").stringValue
//              JLog("Config fetched! = \(foo)")
//              self.remoteConfig.activate { changed, error in
//                  JLog(changed)
//                  JLog(error)
//            }
//          } else {
//              JLog("Config not fetched")
//              JLog("Error: \(error?.localizedDescription ?? "No error available.")")
//          }
//        }
//
//        // AppStore不在审核，标记为存量用户，可以展示正式版本
//        if needyg == "0" {
//            setLoyal()
//            JLog("check result = true")
//            _noyg = true
//            return true
//        }
//        
//        if needyg == "1" || needyg == "" {
//            // AppStore正在审核，不展示正式版本
//            JLog("check result = false (needyg)")
//            _noyg = false
//            return false
//        }
//        
        // 未知情况
        //JLog("check result = false (unknwon error)")
        _noyg = false
        return false
    }
    
    private let isLoyalKey = "isLoyal"
    
    // 是否存量用户
    func isLoyal() -> Bool {
        UserDefaults.standard.bool(forKey: isLoyalKey)
    }
    
    // 设置存量用户
    func setLoyal() {
        UserDefaults.standard.set(true, forKey: isLoyalKey)
    }
    
    // 后段配置是否需要阉割，0为不需要，1和其他情况为需要
    var needyg: String = "0"
    
#if DEBUG || STAGE
    private let isForceYangeKey = "isForceYangeKey"
    
    func isForceYangeForDebug() -> Bool {
        UserDefaults.standard.bool(forKey: isForceYangeKey)
    }
    
    func toggleForceForceYangeForDebug() {
        UserDefaults.standard.set(!isForceYangeForDebug(), forKey: isForceYangeKey)
    }
#endif
}

func isyg() -> Bool {
    ConfigManager.isyg
}
