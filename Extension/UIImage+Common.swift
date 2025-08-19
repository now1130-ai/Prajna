//
//  UIImage+Common.swift
//  UU Wallet
//
//  Created by Dev1 on 2024.03.26.
//

import Foundation
import UIKit

extension UIImage {
    /// Generate gif image based on string
    /// - Parameter jsonStr: jsonStr description
    /// - Returns: description
    static func parseGifFromJSONFile(filePath: String) -> UIImage? {
        guard let jsonData = try? Data(contentsOf: URL(fileURLWithPath: filePath)),
              let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
              let exportSettingsArray = jsonObject["exportSettings"] as? [[String: Any]],
              let firstExportSetting = exportSettingsArray.first,
              let gifFormat = firstExportSetting["format"] as? String,
              gifFormat == "GIF",
              let contentsOnly = firstExportSetting["contentsOnly"] as? Bool, contentsOnly,
              let gifDataString = firstExportSetting["data"] as? String,
              let gifData = Data(base64Encoded: gifDataString),
              let gifImage = UIImage.gifImageWithData(gifData)
        else {
            JLog("Failed to parse GIF data from JSON file.")
            return nil
        }
        return gifImage
    }

    class func gifImageWithData(_ data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            JLog("CGImageSourceCreateWithData failed")
            return nil
        }
        let count = CGImageSourceGetCount(source)
        var images = [UIImage]()

        for i in 0 ..< count {
            if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                let image = UIImage(cgImage: cgImage)
                images.append(image)
            }
        }
        let animatedImage = UIImage.animatedImage(with: images, duration: Double(count) / 10.0)
        return animatedImage
    }
    
    /// 压缩图片
    /// - Parameters:
    ///   - image: image description
    ///   - maxLength: maxLength description
    /// - Returns: description
    class func compressImageSize(image: UIImage, maxLength: Int) -> UIImage {
        // 首先判断原图大小是否在要求内，如果满足要求则不进行压缩，over
        var compression: CGFloat = 1.0
        var data: Data? = image.jpegData(compressionQuality: compression)
        if data == nil { return image }
        if data!.count < maxLength { return image }
        // 原图大小超过范围，先进行“压处理”，这里 压缩比 采用二分法进行处理，6次二分后的最小压缩比是0.015625，已经够小了
        var max: Double = 1
        var min: Double = 0
        for _ in 0 ... 5 {
            compression = (max + min) / 2.0
            data = image.jpegData(compressionQuality: compression)
            if Double(data!.count) < Double(maxLength) * 0.9 {
                min = compression
            } else if data!.count > maxLength {
                max = compression
            } else {
                break
            }
        }
        // 判断“压处理”的结果是否符合要求，符合要求就over
        var resultImage: UIImage? = UIImage(data: data!)
        if resultImage == nil { return image }
        if data!.count < maxLength { return resultImage! }
        // 缩处理，直接用大小的比例作为缩处理的比例进行处理，因为有取整处理，所以一般是需要两次处理
        var lastDataLength = 0
        while data!.count > maxLength && data!.count != lastDataLength {
            lastDataLength = data!.count
            // 获取处理后的尺寸
            let ratio = CGFloat(maxLength) / CGFloat(data!.count)
            let w = resultImage!.size.width * sqrt(ratio)
            let h = resultImage!.size.height * sqrt(ratio)
            let size = CGSize(width: w, height: h)
            // 通过图片上下文进行处理图片
            UIGraphicsBeginImageContext(size)
            resultImage!.draw(in: CGRect(origin: .zero, size: size))
            resultImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            // 获取处理后图片的大小
            data = resultImage!.jpegData(compressionQuality: compression)
        }
        return resultImage ?? image
    }
}
