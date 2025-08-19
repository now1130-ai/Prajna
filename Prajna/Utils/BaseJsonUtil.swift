//
//  BaseJsonUtil.swift
//  UU Wallet
//
//  Created by Dev1 on 2024.03.20.
//

import HandyJSON
import UIKit

class BaseJsonUtil: NSObject {
    /**
     *  Json转对象
     */
    static func jsonToModel(_ jsonStr: String, _ modelType: HandyJSON.Type) -> BaseHandyJSONModel {
        if jsonStr == "" || jsonStr.isEmpty {
            #if DEBUG || STAGE || RELEASE
                JLog("jsonoModel:字符串为空")
            #endif
            return BaseHandyJSONModel()
        }
        return modelType.deserialize(from: jsonStr) as! BaseHandyJSONModel
    }

    /**
     *  Json转数组对象
     */
    static func jsonArrayToModel(_ jsonArrayStr: String, _ modelType: HandyJSON.Type) -> [BaseHandyJSONModel] {
        if jsonArrayStr == "" || jsonArrayStr.isEmpty {
            #if DEBUG || STAGE || RELEASE
                JLog("jsonToModelArray:字符串为空")
            #endif
            return []
        }
        var modelArray: [BaseHandyJSONModel] = []
        let data = jsonArrayStr.data(using: String.Encoding.utf8)
        let peoplesArray = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as? [AnyObject]
        for people in peoplesArray! {
            modelArray.append(dictionaryToModel(people as! [String: Any], modelType))
        }
        return modelArray
    }

    /**
     *  字典转对象
     */
    static func dictionaryToModel(_ dictionStr: [String: Any], _ modelType: HandyJSON.Type) -> BaseHandyJSONModel {
        if dictionStr.isEmpty {
            #if DEBUG || STAGE || RELEASE
                JLog("dictionaryToModel:字符串为空")
            #endif
            return BaseHandyJSONModel()
        }
        return modelType.deserialize(from: dictionStr) as! BaseHandyJSONModel
    }

    // 将字典数组转换成模型数组
    static func parseModelArray<T: HandyJSON>(_ dictArray: [[String: Any]], modelType _: T.Type) -> [T]? {
        if let modelArray = [T].deserialize(from: dictArray) as? [T] {
            return modelArray
        } else {
            return nil
        }
    }

    /**
     *  对象转JSON
     */
    static func modelToJson(_ model: BaseHandyJSONModel?) -> String {
        if model == nil {
            #if DEBUG || STAGE || RELEASE
                JLog("modelToJson:model为空")
            #endif
            return ""
        }
        return (model?.toJSONString())!
    }

    /**
     *  对象转字典
     */
    static func modelToDictionary(_ model: BaseHandyJSONModel?) -> [String: Any] {
        if model == nil {
            #if DEBUG || STAGE || RELEASE
                JLog("modelToJson:model为空")
            #endif
            return [:]
        }
        return (model?.toJSON())!
    }

    /// json字符串转字典
    /// - Parameter text: json字符串
    /// - Returns: 字典
    static func convertStringToDictionary(text: String) -> [String: AnyObject]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: [JSONSerialization.ReadingOptions(rawValue: 0)]) as? [String: AnyObject]
            } catch let error as NSError {
                JLog(error)
            }
        }
        return nil
    }

    /// 模型数组 --> 字典数组
    /// [T] -> [[String: Any]]
    class func toDictArray(from array: [BaseHandyJSONModel]) -> [[String: Any]] {
        return array.toJSON().compactMap { $0 }
    }

//    /// 转模型数组
//    /// - Parameter from: 数组, 通常 元素是字典
//    class func toModelArray(from array: [Any]?) -> [BaseHandyJSONModel] {
//        return [BaseHandyJSONModel].deserialize(from: array)?.compactMap({ $0 }) ?? []
//    }
}
