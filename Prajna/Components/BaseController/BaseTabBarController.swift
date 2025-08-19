//
//  BaseTabBarController.swift
//  UU Wallet
//
//  Created by Dev1 on 2024.03.07.
//

import HandyJSON
import UIKit
import RxSwift
import RxCocoa

class BaseTabBarController: UITabBarController,UINavigationControllerDelegate, UITabBarControllerDelegate {
    private let disposeBag = DisposeBag()
    private var vcArray: [TabBarModel] = []
    deinit {
        JLog("deinit " + NSStringFromClass(type(of: self)))
//        timer.fireDate = Date.distantFuture
//        timer.invalidate()
//        NotificationUtil.remove(observer: self, name: .startUpHomeRequest)
//        NotificationUtil.remove(observer: self, name: .getHomePageAnnouncement)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        JLog("VC Class " + NSStringFromClass(type(of: self)))
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        NotificationUtil.remove(observer: self, name: .startUpHomeRequest)
//        NotificationUtil.remove(observer: self, name: .getHomePageAnnouncement)
    }
    
    /// 是否更新
    private var isUpdate: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        delegate = self
        tabBar.isTranslucent = true
        tabBar.barTintColor = .card
        tabBar.backgroundColor = .card
        UITabBar.appearance().tintColor = .word1
        
//        let homeModel = TabBarModel(vc: HomePageVC(), title: "uu.HomePage".localized, nor: "ic_tab_home_nor", sel: "ic_tab_home_sel")
//        let convertModel = TabBarModel(vc: ConvertTabVC(), title: "uu.Exchange".localized, nor: "ic_tab_convert_nor", sel: "ic_tab_convert_sel")
//        //let cardModel = TabBarModel(vc: PrepaidCardTabViewController(), title: "uu.Card".localized, nor: "ic_tab_card_nor", sel: "ic_tab_card_sel")
//        let cardModel = TabBarModel(vc: CardHomeVC(), title: "uu.Card".localized, nor: "ic_tab_card_nor", sel: "ic_tab_card_sel")
//        let centerModel = TabBarModel(vc: AssetsPageVC(), title: "uu.Assets".localized, nor: "ic_tab_assets_nor", sel: "ic_tab_assets_sel")
//        if Config.noyg {
//            vcArray = [homeModel, convertModel, cardModel, centerModel]
//        } else {
//            vcArray = [homeModel, convertModel, centerModel]
//        }
        updateViewControllers()
//        timer.fireDate = Date.distantPast
        
        NotificationUtil.addObserver(forName: .startUpHomeRequest) { [weak self] _ in
            self?.checkAppVersionUpdate()
        }
        NotificationUtil.addObserver(forName: .getHomePageAnnouncement) { [weak self] _ in
            self?.getAnnouncement()
        }
    }
    
    /// 检测应用更新
    private func checkAppVersionUpdate() {
        if isUpdate {
            return
        }
        isUpdate = true
//        SettingApi.manager.app_Version { [weak self] data in
//            JLog("首页请求")
//            guard let dataSource = data as? [String: Any] else {
//                self?.getAnnouncement()
//                return
//            }
//            guard let records = dataSource["records"] as? [[String: Any]] else {
//                self?.getAnnouncement()
//                return
//            }
//            if isEmptyArr(records) || isEmptyDict(records.first) {
//                self?.getAnnouncement()
//                return
//            }
//            let appVerModel: AppVerModel = BaseJsonUtil.dictionaryToModel(records.first ?? [:], AppVerModel.self) as! AppVerModel
//            // 判断是否需要更新
//            if AppVersionUtil.checkAppVersionIsUpdate(newVersion: appVerModel.version) {
//                // 弹窗更新
//                let updateAlert = VersionUpdateAlertViewController()
//                updateAlert.appVerModel = appVerModel
//                updateAlert.isNotifiAnnounce = true
//                self?.presentPanModal(updateAlert)
//            } else {
//                // 没有更新
//                self?.getAnnouncement()
//            }
//        } fail: { [weak self] errorCode, msg in
//            self?.isUpdate = false
//            self?.getAnnouncement()
//        }
    }
    
    /// 查询首页通知(维护等通知)
    func getAnnouncement() {
//        if !Config.noyg {
//            checkContactSetting()
//            return
//        }
//        JLog("多次请求")
//        SettingApi.manager.homepageAnnouncementV2 { [weak self] data in
//            guard let dataSource = data as? [[String: Any]] else {
//                self?.checkContactSetting()
//                return
//            }
//            let announceArray: [HomepageAnnouncementModel] = BaseJsonUtil.parseModelArray(dataSource, modelType: HomepageAnnouncementModel.self) ?? []
//            // 先弹出底部弹窗，后弹出中部弹窗
//            let middleArr: [HomepageAnnouncementModel] = announceArray.filter { $0.type == 2 }
//            let bottomArr: [HomepageAnnouncementModel] = announceArray.filter { $0.type == 1 }
//            if isEmptyArr(bottomArr) {
//                self?.showNextAlert(models: middleArr)
//            } else {// 底部弹窗
//                let bottomAlert = SystemMaintenanceAlertViewController()
//                bottomAlert.homepageAnnouncementModel = bottomArr.first
//                bottomAlert.dismissFinish = {
//                    self?.showNextAlert(models: middleArr)
//                }
//                self?.presentPanModal(bottomAlert)
//            }
//        } fail: { [weak self] errorCode, msg in
//            self?.checkContactSetting()
//        }
    }
    
    
//    /// 展示中部弹窗
//    /// - Parameter models: models description
//    func showNextAlert(models: [HomepageAnnouncementModel]?) {
//        #warning("控制显示交给后端")
//        let isShowMiddle = UserDefaults.standard.bool(forKey: kIsFirstHomeAnnounce)
//        // && !isShowMiddle
//        if !isEmptyArr(models) && !isShowMiddle {// 中部弹窗
//            let middleAlert = HomePageAnnounceAlert()
//            middleAlert.onDidClose = { [weak self] in
//                self?.checkContactSetting()
//            }
//            middleAlert.show(model: models?.first, inView: view)
//        } else {
//            checkContactSetting()
//        }
//    }
//    
//    /// 是否设置联系方式检查
//    func checkContactSetting() {
//        if UserManager.shared.isLogin {
//            UserManager.shared.getUserModel().checkUser(vc: self)
//        }
//    }
    
    private func updateViewControllers() {
        viewControllers = vcArray.map { model in
            let vc: BaseVC = model.vc
            vc.tabBarItem = UITabBarItem(title: model.title, image: UIImage(named: model.nor), selectedImage: UIImage(named: model.sel))
            vc.tabBarItem.selectedImage = vc.tabBarItem.selectedImage?.withRenderingMode(.alwaysOriginal)
            return BaseNavigationController(rootViewController: vc)
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        viewController.viewWillAppear(animated)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//        let selectedVC = (viewController as! BaseNavigationController).topViewController
//        if (selectedVC is ConvertTabVC) == false {
//            NotificationUtil.post(name: .clearConvertDefault)
//        } else {
//            NotificationUtil.post(name: .reloadConvertDataSource)
//        }
//        if !UserManager.shared.isLogin && selectedVC is AssetsPageVC {
//            RouteUtil.toLoginVC(from: selectedVC as? BaseVC)
//            return false
//        }
        return true
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//        switch tabBarController.selectedIndex {
//        case 0:
//            AnalyTabHomePage.click_nav_home()
//        case 1:
//            AnalyTabHomePage.click_nav_exchange()
//        case 2:
//            AnalyTabHomePage.click_nav_prepaid()
//        case 3:
//            AnalyTabHomePage.click_nav_assets()
//        default:
//            break
//        }
//        
//        CardUtil.isExeTimer = UIApplication.topViewController() is PrepaidCardTabViewController
    }
    
//    // MARK: - setter & getter
//    lazy var timer: Timer = {
//        let tim = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
//        return tim
//    }()
}

private class TabBarModel: HandyJSON {
    var vc: BaseVC
    var title: String
    var nor: String
    var sel: String
    
    init(vc: BaseVC, title: String, nor: String, sel: String) {
        self.vc = vc
        self.title = title
        self.nor = nor
        self.sel = sel
    }
    
    required init() {
        self.vc = BaseVC()
        self.title = ""
        self.nor = ""
        self.sel = ""
    }
}
