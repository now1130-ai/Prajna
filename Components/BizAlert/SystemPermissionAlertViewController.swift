//
//  SystemPermissionAlertViewController.swift
//  JCForex
//
//  Created by gogo on 2025/3/11.
//

import HWPanModal

class SystemPermissionAlertViewController: BaseVC {
    
    var openAction: (() -> Void)?
    var cancelAction: (() -> Void)?
    var icon: String? {
        didSet {
            guard icon != nil else { return }
            iconView.image = UIImage(named: icon!)
        }
    }
    var titleInfo: String?
    var contentInfo: String?


    override func viewDidLoad() {
        super.viewDidLoad()

        navView.isHidden = true

        view.backgroundColor = .card

        view.addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.top.equalTo(32)
            make.centerX.equalTo(view.snp.centerX)
            make.width.height.equalTo(68)
        }
        if !isEmptyStr(icon){
        }
        
        view.addSubview(topTitle)
        topTitle.snp.makeConstraints { make in
            make.top.equalTo(iconView.snp.bottom).offset(24)
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            if titleInfo == nil {
                make.height.equalTo(0)
            }
        }

        view.addSubview(content)
        content.snp.makeConstraints { make in
            make.left.right.equalTo(topTitle)
            if isEmptyStr(contentInfo) {
                make.height.equalTo(0)
                make.top.equalTo(topTitle.snp.bottom).offset(0)
            } else {
                if isEmptyStr(titleInfo) {
                    make.top.equalTo(topTitle.snp.bottom).offset(0)
                } else {
                    make.top.equalTo(topTitle.snp.bottom).offset(16)
                }
            }
        }

        view.addSubview(openBtn)
        openBtn.snp.makeConstraints { make in
            make.top.equalTo(content.snp.bottom).offset(24)
            make.left.right.equalTo(topTitle)
            make.height.equalTo(44)
        }

        view.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { make in
            make.top.equalTo(openBtn.snp.bottom).offset(20)
            make.height.equalTo(44)
            make.bottom.equalTo(-kIndicatorHeight - 20)
            make.left.right.equalTo(topTitle)
        }
    }

    /// 相机权限弹窗
    static func Camera(controller : UIViewController?,openAction: (() -> Void)? = nil){
        if controller == nil {
            return
        }
        let vc = SystemPermissionAlertViewController()
        vc.icon = "ic_permission_camera"
        vc.titleInfo = "PermissionCameraTitle".localized
        vc.contentInfo = "PermissionCameraContent".localized
        vc.openAction = {
            if openAction != nil {
                openAction!()
            }else{
                if let url = URL(string: UIApplication.openSettingsURLString),
                   UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }
        }
        controller!.presentPanModal(vc)
    }
    override func showDragIndicator() -> Bool {
        return false
    }

    override func isAutoHandleKeyboardEnabled() -> Bool {
        return false
    }

    override func longFormHeight() -> PanModalHeight {
        return .init(type: .intrinsic, height: 320)
    }

    // MARK: - setter & getter

    lazy var iconView: UIImageView = {
        let img = UIImageView(image: UIImage(named: "ic_system_maintenance"))
        return img
    }()
    
    var showCancelButton: Bool? {
        didSet {
            guard showCancelButton != nil else { return }
            cancelBtn.isHidden = !showCancelButton!
        }
    }

    lazy var openBtn: BaseButton = {
        let btn = BaseButton.creat(backgroundColor: .theme, font: .creat(type: .MSB, size: 18), textColor: .white)
        btn.setTitle("PermissionOpen".localized, for: .normal)
        btn.setViewCorner(radius: 22)
        btn.tapHandler = { [weak self] _ in
            
            if self?.openAction != nil {
                self?.openAction!()
            }
            
            self?.dismiss(animated: true, completion: {
                
            })
        }
        return btn

    }()

    lazy var cancelBtn: BaseButton = {
        let btn = BaseButton.creat(font: .creat(type: .MSB, size: 14), textColor: .word2)
        btn.setTitle("PermissionCancel".localized, for: .normal)
        btn.tapHandler = { [weak self] _ in
            
            if self?.cancelAction != nil {
                self?.cancelAction!()
            }
            self?.dismiss(animated: true, completion: {
                
            })
        }
        return btn
    }()

    lazy var topTitle: BaseLabel = {
        let lab = BaseLabel.creat(font: .creat(type: .PSB, size: 18), textColor: .word1, textAlignment: .center)
        lab.text = titleInfo
        lab.numberOfLines = 0
        return lab
    }()

    lazy var content: BaseLabel = {
        let lab = BaseLabel.creat(font: .creat(type: .PR, size: 14), textColor: .word2, textAlignment: .center)
        lab.text = contentInfo
        lab.numberOfLines = 0
        return lab
    }()
}

