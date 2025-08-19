//
//  AlertManager.swift
//  UU Wallet
//
//  Created by Dev1 on 2024/5/16.
//

import Foundation
import UIKit

class AlertManager {
    static let shared = AlertManager()

    private var alertList: [BaseAlert] = []
    private var isPresenting = false
    private var currentAlert: BaseAlert?

    /// 移除全部待显示的Alert & 立刻移除正在显示的Alert
    func removeAllAlert() {
        alertList.removeAll()
        if currentAlert != nil {
            currentAlert!.removeFromSuperview()
            currentAlert = nil
        }
    }

    /// error alert
    /// - Parameter error: 错误描述
    func showError(_ error: String) {
        let alert = ErrorAlert(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
        alert.tipLb.text = error
        alertList.append(alert)
        if !isPresenting {
            presentNextAlert()
        }
    }

    /// 网络错误弹框
    func showNetworkError() {
        let alert = NotNetworkAlert(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
        alertList.append(alert)
        if !isPresenting {
            presentNextAlert()
        }
    }

    private func presentNextAlert() {
        guard !alertList.isEmpty else {
            isPresenting = false
            return
        }

        currentAlert = alertList.removeFirst()
        UIApplication.mainWindow()!.addSubview(currentAlert!)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.currentAlert?.removeFromSuperview()
            self?.currentAlert = nil
            self?.presentNextAlert()
        }
        isPresenting = true
    }
}
