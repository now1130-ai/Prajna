//
//  ClickableTextView.swift
//  JCForex
//
//  Created by Niklaus on 2025.05.08.
//

import UIKit

class ClickableTextView: UITextView {

    var clickHandler: ((String) -> Void)?
    
    func setAttributedText(format: String, clickableStrings: [String], clickHandler: @escaping (String) -> Void) {
        self.clickHandler = clickHandler
        
        let formattedText = String(format: format, arguments: clickableStrings)
        let attributedString = NSMutableAttributedString(string: formattedText)
        
        // 设置基本样式
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        paragraphStyle.alignment = textAlignment
        
        attributedString.addAttributes([
            .paragraphStyle: paragraphStyle,
            .font: font ?? UIFont.systemFont(ofSize: 17),
            .foregroundColor: textColor ?? UIColor.black
        ], range: NSRange(location: 0, length: attributedString.length))
        
        // 设置可点击文本样式
        clickableStrings.forEach { clickable in
            let range = (formattedText as NSString).range(of: clickable)
            if range.location != NSNotFound {
                attributedString.addAttributes([
                    .foregroundColor: UIColor.blue,
                    .underlineStyle: NSUnderlineStyle.single.rawValue,
                    .link: "clickable://\(clickable)" // 使用自定义URL方案
                ], range: range)
            }
        }
        
        self.attributedText = attributedString
        self.isEditable = false
        self.isSelectable = true
        self.delegate = self
    }
}

extension ClickableTextView: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if URL.scheme == "clickable" {
            let clickedText = URL.host ?? ""
            clickHandler?(clickedText)
            return false
        }
        return true
    }
}
