//
//  UIView+Common.swift
//  UU Wallet
//
//  Created by Dev1 on 2024.03.15.
//

import Foundation
import UIKit

extension UIView {
    enum CornerStyle {
        case top, left, right, bottom
    }

    /// setCorner
    func setViewCorner(radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }

    func setViewBorder() {
        setViewBorder(color: .border, width: kMinLineH)
        setViewCorner(radius: kRadius)
    }
    
    /// setBorder
    func setViewBorder(color: UIColor, width: CGFloat) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }

    /// setPartCorner
    func setPartViewCorner(radius: CGFloat, style: CornerStyle) {
        layer.cornerRadius = radius
        switch style {
        case .top:
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        case .left:
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        case .right:
            layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        case .bottom:
            layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
    }

    /// addDashedBorder
    /// - Parameters:
    ///   - color: line coloe
    ///   - height: line height
    ///   - dashPattern: weight  line,space exp:[6,3]
    func addDashedBorder(color: UIColor, height: CGFloat, dashPattern: [NSNumber]) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.bounds = bounds
        shapeLayer.anchorPoint = CGPoint(x: 0, y: 0)
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = height
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = dashPattern
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: bounds.size.width, y: 0))
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }

    /// get ViewController On View
    func parentVC() -> BaseVC? {
        var nextResponder = next
        repeat {
            if let vc = nextResponder as? BaseVC {
                return vc
            }
            nextResponder = nextResponder?.next
        } while nextResponder != nil
        return nil
    }

    func loading() {
        CommonLoadingView.shared.showLoading(self)
    }

    func dismiss() {
        CommonLoadingView.shared.dismissLoading()
    }
    
    /// 设置带圆角阴影
    /// - Parameters:
    ///   - radius: radius description
    ///   - shadowColor: shadowColor description
    ///   - shadowOffset: shadowOffset description
    ///   - shadowOpacity: shadowOpacity description
    ///   - shadowRadius: shadowRadius description
    func setShadowBorder(radius:CGFloat, shadowColor: UIColor, shadowOffset:CGSize, shadowOpacity:Float, shadowRadius:CGFloat) {
        layer.cornerRadius = radius
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
    }
    
    /// 添加渐变色
    /// - Parameters:
    ///   - colors: colors description
    ///   - startPoint: startPoint description
    ///   - endPoint: endPoint description
    func applyGradient(colors: [UIColor], startPoint: CGPoint = CGPoint(x: 0, y: 0.5), endPoint: CGPoint = CGPoint(x: 1, y: 0.5)) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.cornerRadius = self.layer.cornerRadius
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    /// 添加撒花特效
    func addFlowerAnimtation() {
        let emitterLayer = CAEmitterLayer()
        emitterLayer.frame = CGRect(x: 0.0, y: -70.0, width: self.frame.size.width, height: 50.0)
        emitterLayer.emitterShape = .rectangle
        emitterLayer.emitterPosition = CGPoint(x: self.frame.size.width / 2, y: 0.0)
        emitterLayer.emitterSize = CGSize(width: self.frame.size.width, height: 50.0)
        // 创建三种不同类型的发射器单元格
        emitterLayer.emitterCells = [
            createCell(with: 0),
            createCell(with: 1),
            createCell(with: 2)
        ]
        self.layer.addSublayer(emitterLayer)
        emitterLayer.birthRate = 1.0
        // 6秒后移除动画
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            emitterLayer.removeFromSuperlayer()
        }
    }
    private func createCell(with type: Int) -> CAEmitterCell {
        let emitterCell = CAEmitterCell()
        // 根据类型设置不同的图片内容
        switch type {
        case 0:
            emitterCell.contents = UIImage(named: "ic_animation_1")?.cgImage
        case 1:
            emitterCell.contents = UIImage(named: "ic_animation_2")?.cgImage
        case 2:
            emitterCell.contents = UIImage(named: "ic_animation_3")?.cgImage
        default:
            break
        }
        // 配置发射器单元格属性
        emitterCell.birthRate = 150.0
        emitterCell.lifetime = 4.0
        emitterCell.lifetimeRange = 1.0
        emitterCell.xAcceleration = 0.0
        emitterCell.yAcceleration = 70.0
        emitterCell.velocity = 20.0
        emitterCell.emissionLongitude = -CGFloat.pi
        emitterCell.velocityRange = 200.0
        emitterCell.emissionRange = CGFloat.pi / 2
        emitterCell.scale = 0.15
        emitterCell.scaleRange = 0.3
        emitterCell.scaleSpeed = -0.02
        return emitterCell
    }
    
    
    /// 中间喷射版撒花动画
    func showFireworkEffect() {
        let emitterLayer = CAEmitterLayer()
        emitterLayer.frame = bounds
        emitterLayer.renderMode = .additive
        emitterLayer.emitterShape = .circle
        emitterLayer.emitterSize = CGSize(width: 200, height: 200) // 更大圆形区域
        emitterLayer.emitterPosition = CGPoint(x: bounds.midX, y: bounds.midY)

        // 三种粒子图像
        let images = [
            UIImage(named: "ic_animation_1")?.cgImage,
            UIImage(named: "ic_animation_2")?.cgImage,
            UIImage(named: "ic_animation_3")?.cgImage
        ].map { $0 ?? makeDefaultParticle() }

        // 创建三个粒子单元
        let cells = images.map { image -> CAEmitterCell in
            let cell = CAEmitterCell()
            cell.contents = image
            cell.birthRate = 80
            cell.lifetime = 5.5
            cell.velocity = 250 // 更高
            cell.velocityRange = 90 // 更离散
            cell.emissionLongitude = -.pi / 2 // 向上
            cell.emissionRange = .pi / 3 // 更宽扇形角度
            cell.scale = 0.15
            cell.scaleRange = 0.015
            //cell.color = UIColor.orange.cgColor
            cell.alphaSpeed = -0.25
            cell.yAcceleration = 150 // 更快下落
            return cell
        }

        emitterLayer.emitterCells = cells
        layer.addSublayer(emitterLayer)

        // 控制时间：5秒喷射，第6秒全部移除
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            emitterLayer.birthRate = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
            emitterLayer.removeFromSuperlayer()
        }
    }
    private func makeDefaultParticle() -> CGImage {
        let size = CGSize(width: 10, height: 10)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.setFillColor(UIColor.white.cgColor)
        ctx.fillEllipse(in: CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image.cgImage!
    }
}

