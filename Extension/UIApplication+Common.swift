//
//  UIApplication+Common.swift
//  UU Wallet
//
//  Created by Dev1 on 25/9/2024.
//

import UIKit
extension UIApplication {
    /// 打开谷歌地图
    /// - Parameters:
    ///   - latitude: 纬度
    ///   - longitude: 经度
    class func openGoogleMaps(latitude: String, longitude: String) {
        // 构建谷歌地图的URL
        let baseUrl = "comgooglemaps://"
        let url = "\(baseUrl)?q=\(latitude),\(longitude)&zoom=14"

        // 检查是否可以打开谷歌地图
        if let url = URL(string: url), UIApplication.shared.canOpenURL(url) {
            // 使用默认方式打开URL
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            // 如果不能打开谷歌地图，则可以选择打开浏览器中的谷歌地图或提醒用户
            let webUrl = "https://www.google.com/maps/?q=\(latitude),\(longitude)&zoom=14"
            if let webURL = URL(string: webUrl) {
                UIApplication.shared.open(webURL, options: [:], completionHandler: nil)
            }
        }
    }

    /// 电话
    /// - Parameter phoneNumber: 电话号码
    class func makePhoneCall(phoneNumber: String) {
        // 清理字符串中可能存在的非数字字符
        let cleanPhoneNumber = phoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()

        // 构建电话URL
        if let url = URL(string: "tel://\(cleanPhoneNumber)") {
            // 检查设备是否能够打开电话URL
            if UIApplication.shared.canOpenURL(url) {
                // 使用默认方式打开URL
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                // 如果无法打开，可以给出适当的提示
                JLog("不能打电话")
            }
        }
    }

    // 获取状态栏高度
    class func getStatusBarHight() -> CGFloat {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                return windowScene.statusBarManager?.statusBarFrame.height ?? 0
            } else {
            return UIApplication.shared.statusBarFrame.size.height
        }
    }

    /// 当前主视图
    /// - Returns: description
    class func mainWindow() -> UIWindow? {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        let window = delegate?.window
        return window
//        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
//            return nil
//        }
//        // 从scene中获取活动的window
//        return windowScene.windows.first(where: { $0.isKeyWindow })
    }

    /// 获取当前展示最上面的viewController
    /// - Parameter controller: controller description
    /// - Returns: description
    class func topViewController(controller: UIViewController? = UIApplication.shared.windows.first!.rootViewController) -> UIViewController? {
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabBarController = controller as? UITabBarController {
            if let selected = tabBarController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        return controller
    }
}


@objc extension UIApplication {
    static func makeToast(_ message: String) {
//        UIApplication.mainWindow()?.makeToast(message)
    }
}
