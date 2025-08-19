//
//  BaseTextField.swift
//  UU Wallet
//
//  Created by Dev1 on 2024.03.14.
//

import UIKit

enum TextFieldType {
    case normal, underLine, card, secureText,
         borderLine, ///边框
         secureBorderText, ///边框，密码输入
         borderLineClear, ///边框，清除
         secureBorderCearText ///边框，密码输入，清除
}

class BaseTextField: UITextField, UITextFieldDelegate {
    ///  小数点输入限制（首位不能为“ . ”，且不能同时输入两个）
    var isPointControl: Bool = false
    /// 最大输入长度（0时可以任意输入） 和 amountScale&amountMaxInt 两个属性不可以同时存在
    var maxInputCount: Int = 0
    /// 和 上面maxInputCount属性不可以同时存在
    /// 输入数量精度(-1时不限精度)
    var amountScale: Int = -1 {
        didSet {
            guard amountScale >= 0 else { return }
            amountMaxInt = 12
        }
    }
    
    /// 精度超过限制的截断回调，方便更新UI
    var scaleMaxCutBack: (() -> Void)?
    
    /// 是否可用长按菜单
    var isMenuAvable: Bool = true
    
    /// 和 上面maxInputCount属性不可以同时存在
    /// 输入金额整数最大长度(0时不限精度)  比如 2 可以输入21.237878 不可以输入 123.333
    var amountMaxInt: Int = 0

    /// 是否账号输入（要帮用户去掉空格）
    var isAccount: Bool = false

    var style: TextFieldType? = nil
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        tintColor = .theme
        textColor = .black
        delegate = self
        autocorrectionType = .no
        smartDashesType = .no
        smartQuotesType = .no
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        tintColor = .theme
        textColor = .black
        delegate = self
        autocorrectionType = .no
        smartDashesType = .no
        smartQuotesType = .no
    }

    init(frame: CGRect, style: TextFieldType) {
        super.init(frame: frame)
        tintColor = .theme
        delegate = self
        textColor = .black
        autocorrectionType = .no
        smartDashesType = .no
        smartQuotesType = .no
        self.style = style
        let defaultLeft: UIView = UIView(frame: CGRectMake(0, 0, 16.0, 10.0))
        let defaultRight: UIView = UIView(frame: CGRectMake(0, 0, 16.0, 10.0))
        // 切换加密按钮
        let secureBtn = BaseButton.creat()
        secureBtn.frame = CGRectMake(0, 0, 44.0, 44.0)
        secureBtn.setImage(UIImage(named: "ic_secureText_open"), for: .selected)
        secureBtn.setImage(UIImage(named: "ic_secureText_close"), for: .normal)
        secureBtn.setIconEdgeConfig(edgeInsets: UIEdgeInsets(top: 13.0, left: 13.0, bottom: 13.0, right: 13.0))
        secureBtn.tapHandler = { [weak self] btn in
            btn.isSelected = !btn.isSelected
            self?.isSecureTextEntry = !btn.isSelected
        }
        // 清除按钮
        let clearBtn = BaseButton.creat()
        clearBtn.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        clearBtn.setImage(UIImage(named: "ic_manual_fieldDelete*12"), for: .selected)
        clearBtn.setImage(UIImage(named: "ic_manual_fieldDelete*12"), for: .normal)
        clearBtn.setIconEdgeConfig(edgeInsets: UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0))
        clearBtn.tapHandler = { [weak self] btn in
            self?.text = nil
        }
        
        switch style {
        case .card:
            backgroundColor = .tfBg
            setViewCorner(radius: 8)
            font = .creat(type: .PM, size: 14)
            setLeftView(view: defaultLeft, mode: .always)
            setRightView(view: defaultRight, mode: .always)
            
        case .secureText:
            backgroundColor = .tfBg
            isSecureTextEntry = true
            setViewCorner(radius: 8)
            font = .creat(type: .PM, size: 14)
            setLeftView(view: defaultLeft, mode: .always)
            setRightView(view: secureBtn, mode: .always)
            
        case .borderLine:
            setViewCorner(radius: 8)
            setViewBorder(color: .border, width: kMinLineH * 2)
            font = .creat(type: .PM, size: 14)
            setLeftView(view: defaultLeft, mode: .always)
            setRightView(view: defaultRight, mode: .always)
            
        case .secureBorderText:
            isSecureTextEntry = true
            setViewBorder(color: .border, width: kMinLineH * 2)
            setViewCorner(radius: 8)
            font = .creat(type: .PM, size: 14)
            setLeftView(view: defaultLeft, mode: .always)
            setRightView(view: secureBtn, mode: .always)
            
        case .borderLineClear:
            setViewCorner(radius: 8)
            setViewBorder(color: .border, width: kMinLineH * 2)
            font = .creat(type: .PM, size: 14)
            setLeftView(view: defaultLeft, mode: .always)
            setRightView(view: clearBtn, mode: .whileEditing)
            
        case .secureBorderCearText:
            isSecureTextEntry = true
            setViewCorner(radius: 8)
            setViewBorder(color: .border, width: kMinLineH * 2)
            font = .creat(type: .PM, size: 14)
            setLeftView(view: defaultLeft, mode: .always)
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 44 * 2 + 8, height: 48))
            view.addSubview(clearBtn)
            secureBtn.frame = CGRectMake(44 + 4, 0, 48.0, 48.0)
            view.addSubview(secureBtn)
            setRightView(view: view, mode: .whileEditing)
        default:
            break
        }
    }
        
//    // 可选：禁用长按手势弹出菜单
//    override func addGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) {
//        if gestureRecognizer is UILongPressGestureRecognizer {
//            gestureRecognizer.isEnabled = false
//        }
//        super.addGestureRecognizer(gestureRecognizer)
//    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        // 禁用复制、粘贴和选择操作
        // 复制操作 copy(_:):  剪切操作 cut(_:):  粘贴操作 paste(_:):  选择操作 select(_:):  全选操作 selectAll(_:):
        let copyAction: Selector = #selector(UIResponderStandardEditActions.copy(_:))
        let cutAction: Selector = #selector(UIResponderStandardEditActions.cut(_:))
        let pasteAction: Selector = #selector(UIResponderStandardEditActions.paste(_:))
        let selectAction: Selector = #selector(UIResponderStandardEditActions.select(_:))
        let selectAllAction: Selector = #selector(UIResponderStandardEditActions.selectAll(_:))
        let deleteAction: Selector = #selector(UIResponderStandardEditActions.delete(_:))
        var isMove = false
        if #available(iOS 16.0, *) {
            let moveAction: Selector = #selector(UIResponderStandardEditActions.move(_:))
            isMove = action == moveAction
        } else {
            // Fallback on earlier versions
        }
        var isDuplicate = false
        if #available(iOS 16.0, *) {
            let duplicateAction: Selector = #selector(UIResponderStandardEditActions.duplicate(_:))
            isDuplicate = action == duplicateAction
        } else {
            // Fallback on earlier versions
        }

        
        if !isMenuAvable {
            return false
        }
        
        if isPointControl && (action == copyAction || action == cutAction || action == pasteAction || action == selectAction || action == selectAllAction || action == deleteAction || isMove || isDuplicate) {
            return false
        }
        // 允许其他操作
        return super.canPerformAction(action, withSender: sender)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var stringTemp = string
        
        #warning("替换 `,` 为 `.`")
        let filteredString = string.replacingOccurrences(of: ",", with: ".")
        if filteredString != string && textField.keyboardType == .decimalPad {
            textField.text = (textField.text ?? "") + filteredString
            return false
        }
        
//        if textField.keyboardType == .decimalPad && stringTemp.contains(",") {
//            stringTemp = stringTemp.replacingOccurrences(of: ",", with: ".")
//            textField.text = textField.text?.replacingOccurrences(of: ",", with: ".")
//        }
        
        if isPointControl && stringTemp == "," {
            stringTemp = "."
        }

        // 检查是否是删除操作
        let isDeleting = stringTemp.isEmpty && range.length == 1
        // 检查是否光标在文本末尾
        let cursorAtEnd = range.location + range.length == textField.text?.count
        // 只有在光标在文本末尾且是删除操作时才允许删除输入字符
        if isDeleting && !cursorAtEnd && isPointControl {
            return false
        }

        // 如果是空格字符，则不允许添加到文本字段中
        let isSpace = string.rangeOfCharacter(from: .whitespaces) != nil
        if isSpace && isAccount {
            return false
        }

        // 检查替换的字符串是否为小数点，并且当前文本中已经存在一个以上的小数点
        if stringTemp == "." && (textField.text?.contains(".") ?? false && isPointControl) {
            return false
        }
        // 检查第一个字符是否为小数点
        if stringTemp == "." && range.location == 0 && isPointControl {
            return false
        }
        // 输入第一个为 0 第二个必须为 .
        if isPointControl && textField.text?.prefix(1) == "0" && range.location == 1 {
            return stringTemp == "." || stringTemp == ""
        }

        let newText = (textField.text! as NSString).replacingCharacters(in: range, with: stringTemp).replacingOccurrences(of: ",", with: "")

        // 最大输入限制
        if maxInputCount > 0 {
            // 只 设置 maxInputCount
            return newText.count <= maxInputCount
        }

        // 精度为0时首位不能为0同时不能输入小数点
        if amountScale == 0 && (stringTemp == "." || (stringTemp == "0" && range.location == 0)) {
            return false
        }

        // 货币数量输入限定
        if amountScale >= 0 && amountMaxInt > 0 {
            // 含小数点
            if let dotRange = newText.range(of: ".") {
                let fractionPart = newText.suffix(from: dotRange.upperBound)
                let integerPart = newText.prefix(upTo: dotRange.lowerBound)
                if fractionPart.count > amountScale {
                    // 如果小数点后的字符数量大于 amountScale，拒绝输入
                    
                    //扫码或复制引发金额的精度大于amountScale，这时候无法输入
                    //暂时用截取处理，以解决无法输入
                    let fractionPartStr = "\(fractionPart)"
                    textField.text = "\(integerPart).\(fractionPartStr.prefix(amountScale))"
                    if scaleMaxCutBack != nil {
                        self.scaleMaxCutBack!()
                    }
                    return false
                }
                if integerPart.count > amountMaxInt {
                    // 如果整数部分大于 amountMaxInt，拒绝输入
                    return false
                }
            } else {
                // 不含小数点
                return newText.count <= amountMaxInt
            }
        }
        // 允许其他情况
        return true
    }
    
    // MARK: - 扩展方法

    func setLeftView(view: UIView, mode: ViewMode) {
        let container = UIView(frame: view.frame)
        container.addSubview(view)
        view.center = container.center
        leftView = container
        leftViewMode = mode
    }

    func setRightView(view: UIView, mode: ViewMode) {
        let container = UIView(frame: view.frame)
        container.addSubview(view)
        view.center = container.center
        rightView = container
        rightViewMode = mode
    }

    func setAttrPlaceholder(placeholder: String, color: UIColor) {
        let attrStr = NSMutableAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: color])
        attributedPlaceholder = attrStr
    }
}
