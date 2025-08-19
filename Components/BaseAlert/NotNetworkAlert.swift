//
//  NotNetworkAlert.swift
//  UU Wallet
//
//  Created by Dev1 on 2024/6/12.
//

import SnapKit
import UIKit

class NotNetworkAlert: BaseAlert {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(bgV)
        bgV.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY)
            make.width.equalTo(170)
        }

        bgV.addSubview(iconImg)
        iconImg.snp.makeConstraints { make in
            make.top.equalTo(16)
            make.width.height.equalTo(54)
            make.centerX.equalTo(bgV)
        }

        bgV.addSubview(tipLb)
        tipLb.snp.makeConstraints { make in
            make.left.equalTo(12)
            make.right.equalTo(-12)
            make.top.equalTo(iconImg.snp.bottom).offset(16)
            make.bottom.equalTo(-16)
        }
    }

    static func showErrorInView(_ view: UIView, error: String) {
        let alert = ErrorAlert()
        alert.tipLb.text = error
        alert.showIn(view: view)
    }

    // MARK: - getter & setter

    lazy var bgV: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(white: 0.4, alpha: 0.6)
        v.backgroundColor = .word2
        v.setViewCorner(radius: 24)
        return v
    }()

    lazy var iconImg: UIImageView = {
        let v = UIImageView(image: UIImage(named: "ic_alert_network"))
        return v
    }()

    lazy var tipLb: BaseLabel = {
        let v = BaseLabel.creat(font: .creat(type: .PR, size: 12), textColor: .white, textAlignment: .center)
        v.text = "uu.There is a current network error".localized
        return v
    }()
}
