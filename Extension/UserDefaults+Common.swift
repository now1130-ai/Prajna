//
//  UserDefaults+Common.swift
//  UU Wallet
//
//  Created by Dev1 on 25/9/2024.
//

import Foundation
extension UserDefaults {
    /// 获取生物识别状态
    /// - Returns: description
    class func getBiometricState() -> Bool {
        return UserDefaults.standard.bool(forKey: kIsBiometric)
    }

    class func saveBiometricState(isBiometric: Bool) {
        UserDefaults.standard.set(isBiometric, forKey: kIsBiometric)
    }
}
