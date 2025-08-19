//
//  UIButton+Common.swift
//  JCForex
//
//  Created by gogo on 2025/2/5.
//

import Foundation

private var clickDelayTime = "clickDelayTime"
private var defaultDelayTime: TimeInterval = 0.0 //默认两次点击无间隔
private var lastClickTime: TimeInterval = 0.0 //记录上次点击时刻

extension UIButton {

    var delayTime: TimeInterval {
        set {
            objc_setAssociatedObject(self, &clickDelayTime, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            if let clickDelayTime = objc_getAssociatedObject(self, &clickDelayTime) as? TimeInterval {
                return clickDelayTime
            }
            return defaultDelayTime
        }
    }
    
    open override func sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        // 未设置delayTime值或者设置为0s间隔
        if delayTime == 0 {
            super.sendAction(action, to: target, for: event)
        } else {
            // 这里当前点击时刻用timeIntervalSince1970作为参考值，也可以取其他
            // 两次点击时间间隔大于设定值，响应
            if Date().timeIntervalSince1970 - lastClickTime > delayTime {
                super.sendAction(action, to: target, for: event)
                // 更新本次点击时刻
                lastClickTime = Date().timeIntervalSince1970
            }
        }
    }
    
    /// 设置图片边距
    /// - Parameter edgeInsets: edgeInsets description
    func setIconEdgeConfig(edgeInsets: UIEdgeInsets) {
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.plain() // 选择合适的按钮样式
            config.image = image(for: .normal) // 继承原来的图片
            // 设置图片与按钮边界的间距
            //config.imagePadding = 8 // 控制上下 padding（与 top 和 bottom 作用类似）
            //config.imagePlacement = .leading // 图片默认在左侧
            // 使用 contentInsets 来调整左侧的额外间距
            config.contentInsets = NSDirectionalEdgeInsets(top: edgeInsets.top, leading: edgeInsets.left, bottom: edgeInsets.bottom, trailing: edgeInsets.right)
            configuration = config
        } else {
            // 兼容 iOS 15 以下的代码
            imageEdgeInsets = edgeInsets
        }
    }
    
    /// 设置内部布局
    /// - Parameters:
    ///   - titleEdge: title
    ///   - iconEdge: image
    ///   - contentEdge: contentEdge description
    func setTitleAndIconEdgeConfig(titleEdge: UIEdgeInsets, iconEdge: UIEdgeInsets) {
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.plain()
            config.image = image(for: .normal) // 继承原来的图片
            config.title = title(for: .normal) // 继承原来的文本
            // 1️⃣ 兼容 titleEdgeInsets
            config.titlePadding = titleEdge.left
            // 2️⃣ 兼容 imageEdgeInsets
            // 由于 iOS 15+ 不支持 `imageEdgeInsets`，我们使用 contentInsets 进行偏移
            config.contentInsets = NSDirectionalEdgeInsets(
                top: 0,
                leading: 0, // 整体内容左侧间距
                bottom: 0,
                trailing: 0  // 整体内容右侧间距
            )
            // 手动调整 image 位置
            config.imagePlacement = .trailing // 确保图片在右侧
            config.imagePadding = iconEdge.left - iconEdge.right // 计算图片的偏移量
            configuration = config
        } else {
            // 兼容 iOS 14 及以下的代码
            titleEdgeInsets = titleEdge
            imageEdgeInsets = iconEdge
            contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
}
