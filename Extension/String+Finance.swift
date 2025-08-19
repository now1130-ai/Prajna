//
//  String+Finance.swift
//  UU Wallet
//
//  Created by Dev1 on 22/10/2024.
//

extension String {
    /// 获取货币显示格式的字符串
    ///
    /// 此方法将字符串转换为货币显示格式,包括千位分隔符和可选的小数位限制（向下去整）。
    /// 主要功能包括:
    /// 1. 处理整数和小数部分
    /// 2. 根据指定的最大小数位数截断小数部分
    /// 3. 使用NumberFormatter添加千位分隔符
    ///
    /// - Parameter maximumFractionDigits: 小数部分最大保留的位数。如果为nil,则不限制小数位数。
    /// - Returns: 格式化后的货币字符串。如果转换失败,则返回空字符串。
    func getCoinText(maximumFractionDigits: Int? = nil) -> String {
        // 分割字符串以获取整数部分和小数部分
        let parts = split(separator: ".", maxSplits: 1, omittingEmptySubsequences: false)
        
        var digits = maximumFractionDigits
        if digits == nil && parts.count > 1{
            digits =  String(parts[1]).count
        }
        
        let integerPart = String(parts[0])

        var fractionalPart = parts.count > 1 ? String(parts[1]) : ""
        // 截取小数部分
        if let maxDigits = maximumFractionDigits {
            fractionalPart = String(fractionalPart.prefix(maxDigits))
        }
        // 确保小数部分长度至少等于最小小数位数 - 需要添加0 就打开  比如 1显示成1.00
//        if let minDigits = minimumFractionDigits, fractionalPart.count < minDigits {
//            fractionalPart += String(repeating: "0", count: minDigits - fractionalPart.count)
//        }
        // 组合整数部分和处理后的小数部分
        let truncatedString = fractionalPart.isEmpty ? integerPart : "\(integerPart).\(fractionalPart)"

        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.init(identifier: "en_US")
        // 货币符号
        formatter.currencySymbol = ""
        // 设置小数点后最多保留
        if digits != nil {
            formatter.maximumFractionDigits = digits!
        }
        // 设置小数点后最少保留
        formatter.minimumFractionDigits = 0
        // 设置分号作为分组分隔符
        // formatter.groupingSeparator = "."
        guard let number = formatter.number(from: truncatedString) else { return "" }
        var str = formatter.string(from: number) ?? ""
        #warning("为什么非要加小数点00呢")
//        if str == "0" {
//            str = amountZeroStr
//        }
        return str
    }
    
    /// 精确2位小数点
    /// 参考 getCoinText
    func getCoin2Text() -> String {
        if self == "0" {
            return amountZeroStr
        }
        return getCoinText(maximumFractionDigits: 2)
    }
    
    /// 根据指定精度对金额字符串进行裁剪
    /// 仅在换汇主页使用
    ///
    /// 此方法主要用于控制金额字符串的小数位数,具体功能包括:
    /// 1. 如果字符串为空,直接返回空字符串
    /// 2. 如果字符串中没有小数点,则返回原字符串
    /// 3. 根据指定的scale(精度)裁剪小数部分:
    ///    - 如果scale为nil或负数,则只保留整数部分
    ///    - 否则,保留指定位数的小数(包括小数点)
    ///
    /// - Parameter scale: 要保留的小数位数。如果为nil或负数,则只保留整数部分。
    /// - Returns: 按指定精度裁剪后的字符串。
    func formatAmountWith(scale: Int?) -> String {
        if isEmptyStr(self) {
            return ""
        }
        guard let dotIndex = firstIndex(of: ".") else {
            return self // 如果没有小数点，则直接返回原始字符串
        }
        let integerPart = self[..<dotIndex] // 整数部分
        let decimalPart = self[dotIndex...] // 小数部分
        // 裁剪小数部分以保留指定的精度
        if scale == nil || scale! <= 0 {
            // let truncatedDecimalPart = decimalPart.prefix(2 + 1)
            // 拼接整数部分和裁剪后的小数部分
            // let formattedString = "\(integerPart)\(truncatedDecimalPart)"
            return String(integerPart)
        } else {
            let truncatedDecimalPart = decimalPart.prefix(scale! + 1)
            // 拼接整数部分和裁剪后的小数部分
            let formattedString = "\(integerPart)\(truncatedDecimalPart)"
            return String(formattedString)
        }
    }
    
    
    /// 获取整数倍最大公约数
    /// - Parameter count: 次方
    /// - Returns: description
    func findLargestDivisibleNumber(count: Int?) -> String {
        // 检查 self 是否能转换为整数
        guard let amountInt = Int(self) else {
            return "0"
        }
        if self.equalZero() == true {
            return "0"
        }
        guard let count = count else {
            return self
        }
        // 检查 count 是否为非负数
        guard count >= 0 else {
            return "0"
        }
        // 计算 10^count
        let divisor = Int(pow(10.0, Double(count)))
        // 计算余数并调整到最大的可整除数
        let remainder = amountInt % divisor
        let result = amountInt - remainder
        // 确保结果 >= 0
        return result >= 0 ? String(result) : "0"
    }
}
