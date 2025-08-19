//
//  BaseAlert.swift
//  UU Wallet
//
//  Created by Dev1 on 2024/5/16.
//

import SnapKit
import UIKit

class BaseAlert: UIView {
    deinit {
        JLog("deinit " + NSStringFromClass(type(of: self)))
    }

    func showIn(view: UIView) {
        view.addSubview(self)
        snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.removeFromSuperview()
        }
    }
}
