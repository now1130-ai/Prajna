//
//  BaseVC.swift
//  UU Wallet
//
//  Created by Dev1 on 2024.03.07.
//

import SnapKit
import UIKit
import RxCocoa
import RxSwift


class BaseVC: UIViewController {
    var disposeBag = DisposeBag()
    deinit {
        JLog("deinit " + NSStringFromClass(type(of: self)))
    }

    override func viewWillAppear(_: Bool) {
        JLog("VC Class " + NSStringFromClass(type(of: self)))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .vcBg
        initVal()
        initView()
        getData()
    }

    func initVal(){
        
    }
    
    func initView(){
        initNavView()
    }
    
    func getData(){
        
    }
    func initNavView(){
        view.addSubview(navView)
        navView.snp.makeConstraints { make in
            make.top.left.right.equalTo(view)
            make.height.equalTo(kNavBarHeight)
        }
        navView.addSubview(navBtn)
        navBtn.snp.makeConstraints { make in
            make.centerY.equalTo(navView.snp.top).offset(kStatusBarHeight + 22)
            make.left.equalTo(20)
            make.width.height.equalTo(24)
        }
//        navView.addSubview(navServiceBtn)
//        navServiceBtn.snp.makeConstraints { make in
//            make.centerY.equalTo(navView.snp.top).offset(kStatusBarHeight + 22)
//            make.right.equalTo(-20.0)
//            make.width.height.equalTo(24.0)
//        }
//        navView.addSubview(navQuestBtn)
//        navQuestBtn.snp.makeConstraints { make in
//            make.centerY.equalTo(navView.snp.top).offset(kStatusBarHeight + 22)
//            make.right.equalTo(-20.0)
//            make.width.height.equalTo(24.0)
//        }
        
        
        initNavTitle()
        navView.isHidden = navigationController?.viewControllers.first == self
    }
    
    func initNavTitle(){
        navView.addSubview(titleLb)
        titleLb.snp.makeConstraints { make in
            //make.centerX.equalTo(navView)
            make.bottom.equalTo(navView)
            make.height.equalTo(44)
            //make.width.equalTo(244)
            make.left.equalTo(64.0)
            make.right.equalTo(-64.0)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        view.endEditing(true)
    }

    @objc func navBackClick() {
        navigationController?.popViewController(animated: true)
    }
    
    /// 跳转之后移除当前控制器
    func removeCurrentVC() {
        if let navController = self.navigationController {
            var viewControllers = navController.viewControllers
            // 在 push 成功后移除当前控制器
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { // 适当延迟确保动画完成
                viewControllers.removeAll { $0 == self }
                navController.viewControllers = viewControllers
            }
        }
        
        
//        如果你想要确保 push 后导航栈里没有当前页面 (即无论何时都移除当前控制器)，可以这样：
//        if let navController = self.navigationController {
//            let newViewController = NewViewController()
//            
//            var viewControllers = navController.viewControllers
//            viewControllers.append(newViewController) // 先添加新页面
//            viewControllers.removeAll { $0 == self } // 再移除当前控制器
//            
//            navController.setViewControllers(viewControllers, animated: true)
//        }
//        直接设置 setViewControllers(_, animated:)，不会触发 pushViewController(_:animated:) 的动画。
//        适用于一些特殊需求，比如 push 过程中避免动画干扰。
    }
    
    
    func showLoading(){
        CommonLoadingView.shared.showLoading(view)
    }
    
    func dismissLoading(){
        CommonLoadingView.shared.dismissLoading()
    }
    
    func showErrorLocal(str:String){
        showError(str: str.localized)
    }
    
    func showError(str:String){
        ErrorAlert.showErrorInView(self.view, error: str)
    }

    // MARK: - setter & getter

    lazy var navView: UIView = {
        let view = UIView()
        return view
    }()

    lazy var navBtn: BaseButton = {
        let btn = BaseButton.creat()
        btn.setImage(UIImage(named: "ic_navbar_back"), for: .normal)
        btn.tapHandler = { [weak self] _ in
            self?.navBackClick()
        }
        return btn
    }()

    lazy var titleLb: BaseLabel = {
        let label = BaseLabel.creat(font: .creat(type: .PSB, size: 20), textColor: .word1, textAlignment: .center)
        return label
    }()
    
//    lazy var navServiceBtn: BaseButton = {
//        let btn = BaseButton.creat()
//        btn.isHidden = true
//        btn.setImage(UIImage(named: "ic_navbar_service"), for: .normal)
//        btn.setIconEdgeConfig(edgeInsets: UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2))
//        btn.tapHandler = { [weak self] btn in
//            RouteUtil.web(vc: self, webType: .contactUs)
//        }
//        return btn
//    }()
//    lazy var navQuestBtn: BaseButton = {// 登录注册常见问题（找回账号）
//        let btn = BaseButton()
//        btn.isHidden = true
//        btn.setImage(UIImage(named: "ic_question"), for: .normal)
//        btn.tapHandler = { [weak self] btn in
//            let vc = LoginQuestionVC()
//            self?.navigationController?.pushViewController(vc, animated: true)
//        }
//        return btn
//    }()
}
