//
//  BaseStackItem.swift
//  UU Wallet
//
//  Created by Dev1 on 2024.03.27.
//

import UIKit
import QMUIKit

class BaseStackItem: UIStackView {
    var valueTapAction: (() -> Void)?

    var isCopy: Bool? {
        didSet {
            guard isCopy != nil else { return }
            if isCopy! {
                self.value.numberOfLines = 1
                self.value.lineBreakMode = .byTruncatingMiddle
                
                addArrangedSubview(copyBtn)
                let topConstraint = copyBtn.topAnchor.constraint(equalTo: self.topAnchor, constant: 2)
                let topConstraintTitle = title.topAnchor.constraint(equalTo: self.topAnchor)
                let topConstraintValue = value.topAnchor.constraint(equalTo: self.topAnchor)
                let topConstraintBtn = copyBtn.topAnchor.constraint(equalTo: self.topAnchor)

                NSLayoutConstraint.activate([
                    topConstraint,
                    copyBtn.widthAnchor.constraint(equalToConstant: 24),
                    copyBtn.heightAnchor.constraint(equalToConstant: 24),
                    topConstraintTitle,
                    topConstraintValue,
                    topConstraintBtn
                ])
                
            } else {
                removeArrangedSubview(copyBtn)
            }
        }
    }

//    var isIcon:Bool? {
//        didSet {
//            guard isIcon != nil else {return}
//            if isIcon! {
//                insertArrangedSubview(icon, at: 0)
    ////                let topConstraint = icon.topAnchor.constraint(equalTo: self.topAnchor, constant: -10)
    ////                let topConstraintTitle = title.topAnchor.constraint(equalTo: self.topAnchor)
    ////                let topConstraintValue = value.topAnchor.constraint(equalTo: self.topAnchor)
    ////                let topConstraintBtn = copyBtn.topAnchor.constraint(equalTo: self.topAnchor)
    ////
    ////                NSLayoutConstraint.activate([
    ////                    topConstraint,
    ////                    icon.widthAnchor.constraint(equalToConstant: 24),
    ////                    icon.heightAnchor.constraint(equalToConstant: 24),
    ////                    topConstraintTitle,
    ////                    topConstraintValue,
    ////                    topConstraintBtn
    ////                ])
//            } else {
//                removeArrangedSubview(icon)
    ////                let topConstraintTitle = title.topAnchor.constraint(equalTo: self.topAnchor)
    ////                let topConstraintValue = value.topAnchor.constraint(equalTo: self.topAnchor)
    ////                let topConstraintBtn = copyBtn.topAnchor.constraint(equalTo: self.topAnchor)
    ////                NSLayoutConstraint.activate([
    ////                    topConstraintTitle,
    ////                    topConstraintValue,
    ////                    topConstraintBtn
    ////                ])
//            }
//        }
//    }

    @available(*, unavailable)
    required init(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        axis = .horizontal
        spacing = 8
        alignment = .leading
        distribution = .fill
        translatesAutoresizingMaskIntoConstraints = false
        addArrangedSubview(title)
        addArrangedSubview(value)
        // icon.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        title.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        value.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        copyBtn.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }

    @objc private func tapAction() {
        if valueTapAction != nil {
            valueTapAction!()
        }
    }

    // MARK: - setter & getter

    lazy var icon: UIImageView = {
        let img = UIImageView()
        img.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        return img
    }()

    lazy var title: BaseLabel = {
        let lab = BaseLabel.creat(font: .creat(type: .PR, size: 14), textColor: .word1)
        return lab
    }()

    lazy var value: BaseLabel = {
        let lab = BaseLabel.creat(font: .creat(type: .PM, size: 14), textColor: .word1, textAlignment: .right)
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        lab.addGestureRecognizer(tap)
        lab.isUserInteractionEnabled = true
        return lab
    }()

    lazy var copyBtn: BaseButton = {
        let btn = BaseButton.creat()
        btn.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        btn.setImage(UIImage(named: "ic_copy_20*20"), for: .normal)
        btn.tapHandler = { [weak self] _ in
            guard self!.value.text != nil else { return }
            UIPasteboard.general.string = self!.value.text
            QMUITips.show(withText: "uu.Copied successfully".localized, in: self!.parentVC()!.view)
        }
        return btn
    }()
}
