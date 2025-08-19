//
//  BaseNavigationController.swift
//  UU Wallet
//
//  Created by Dev1 on 2024.03.07.
//

import UIKit

class BaseNavigationController: UINavigationController, UINavigationControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
        delegate = self
        setNavigationBarHidden(true, animated: false)
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if !viewControllers.isEmpty {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }

    func navigationController(_: UINavigationController, didShow viewController: UIViewController, animated _: Bool) {
        var isPop = true
        if viewController == viewControllers.first {
            isPop = false
        }
        interactivePopGestureRecognizer?.isEnabled = isPop
    }
}
