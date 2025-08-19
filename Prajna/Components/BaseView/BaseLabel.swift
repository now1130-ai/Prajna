//
//  BaseLabel.swift
//  UU Wallet
//
//  Created by Dev1 on 2024.03.11.
//

import UIKit

class BaseLabel: UILabel {
    
    // 关联对象键
    private var totalStr: String = ""
    private var subStrings: [String] = []
    
    // 关联对象键
    private static var clickHandlerKey: UInt8 = 0
    
    class func creat(font: UIFont? = nil, textColor: UIColor? = nil, textAlignment: NSTextAlignment? = nil) -> BaseLabel {
        let label = BaseLabel()
        label.numberOfLines = 0
        if font != nil { label.font = font }
        if textColor != nil { label.textColor = textColor } else { label.textColor = .word1 }
        if textAlignment != nil { label.textAlignment = textAlignment! }
        return label
    }
    
    func setAttributedText(format: String, clickableStrings: [String], clickHandler: @escaping (String) -> Void) {
        let formattedText = String(format: format, arguments: clickableStrings)
        totalStr = formattedText
        subStrings = clickableStrings
        let attributedString = NSMutableAttributedString(string: formattedText)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        paragraphStyle.alignment = textAlignment
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        clickableStrings.forEach { clickable in
            let range = (formattedText as NSString).range(of: clickable)
            if range.location != NSNotFound {
                attributedString.addAttributes([
                    .foregroundColor: UIColor.theme
                ], range: range)
            }
        }
        self.attributedText = attributedString
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.addGestureRecognizer(tapGesture)
        objc_setAssociatedObject(self, &BaseLabel.clickHandlerKey, clickHandler, .OBJC_ASSOCIATION_COPY_NONATOMIC)
    }
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        guard let label = gesture.view as? UILabel,
        let attributedText = label.attributedText,
        let clickHandler = objc_getAssociatedObject(self, &BaseLabel.clickHandlerKey) as? (String) -> Void else { return }
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize(width: label.bounds.width, height: CGFloat.greatestFiniteMagnitude))
        let textStorage = NSTextStorage(attributedString: attributedText)

        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        textContainer.size = label.bounds.size

        let location = gesture.location(in: label)
        let characterIndex = layoutManager.characterIndex(for: location, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)

        // 遍历匹配点击的文本
        for clickable in subStrings {
            let range = (attributedText.string as NSString).range(of: clickable)
            if NSLocationInRange(characterIndex, range) {
                clickHandler(clickable)
                return
            }
        }
    }
}
