//
//  BaseButton.swift
//  UU Wallet
//
//  Created by Dev1 on 2024.03.15.
//

import UIKit
import RxCocoa
import RxSwift

enum BaseButtonType {
    case normal // 常规按钮
    case countdown// 发送按钮
    case sendCode// 新版验证码按钮
}

class BaseButton: UIButton {
    var style:BaseButtonType = .normal
    
    private let disposeBag = DisposeBag()
    // 定义按钮点击事件的闭包属性
    var tapHandler: ((BaseButton) -> Void)?
    
    /// 是否可用
    var isUsable: Bool? {
        didSet {
            guard isUsable != nil else { return }
            isEnabled = isUsable!
            switch style {
            case .countdown:
                alpha = isUsable! ? 1 : 0.5
            default:
                setTitleColor(isUsable! ? .white : .white.withAlphaComponent(0.5), for: .normal)
                break
            }
        }
    }
    
    var timer: Timer?
    var timeLeft = 60 // 倒计时时间，单位秒
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 创建一个Observable来监听按钮点击事件
        let tapObservable = rx.tap.asObservable()
        // 使用throttle操作符限制事件发送频率为0.5秒 // debounce
        tapObservable
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.handleButtonTap()
            })
            .disposed(by: disposeBag)
    }
    private func handleButtonTap() {
        // 调用按钮点击事件的闭包
        tapHandler?(self)
    }

    /// 创建常规按钮
    /// - Parameters:
    ///   - backgroundColor: backgroundColor description
    ///   - font: font description
    ///   - textColor: textColor description
    ///   - textAlignment: textAlignment description
    /// - Returns: description
    class func creat(btnStyle:BaseButtonType? = nil, backgroundColor: UIColor? = nil, font: UIFont? = nil, textColor: UIColor? = nil, textAlignment: UIControl.ContentHorizontalAlignment? = nil) -> BaseButton {
        let btn = BaseButton()
        if backgroundColor != nil { btn.backgroundColor = backgroundColor }
        btn.contentHorizontalAlignment = .center
        if btnStyle != nil { btn.style = btnStyle ?? .normal }
        if font != nil { btn.titleLabel?.font = font }
        if textColor != nil { btn.setTitleColor(textColor, for: .normal) }
        if textAlignment != nil { btn.contentHorizontalAlignment = textAlignment! }
        switch btn.style {
        case .countdown:
            btn.setTimerTitle()
            btn.titleLabel?.adjustsFontSizeToFitWidth = true
        default:
            break
        }
        
        return btn
    }
    
    func setTimerTitle(){
        setTitle("register/getCode".localized, for: .normal)
        isUsable = true
    }
    
    func startTimer() {
        isUsable = false
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if self.timeLeft > 0 {
                self.timeLeft -= 1
                self.setTitle("\(self.timeLeft) s", for: .normal)
            } else {
                self.stopTimer()
            }
        }
    }
    
    func stopTimer(){
        timer?.invalidate() // 停止计时器
        self.setTimerTitle()
    }

    /// 按钮区域扩成44*44
    override func point(inside point: CGPoint, with _: UIEvent?) -> Bool {
        var boundsTemp: CGRect = bounds
        // 若原热区小于44x44，则放大热区，否则保持原大小不变
        let widthDelta = max(44.0 - boundsTemp.size.width, 0)
        let heightDelta = max(44.0 - boundsTemp.size.height, 0)
        boundsTemp = boundsTemp.insetBy(dx: -0.5 * widthDelta, dy: -0.5 * heightDelta)
        return boundsTemp.contains(point)
    }
    
}
