//
//  Log.swift
//  UU Wallet
//
//  Created by Dev1 on 29/10/2024.
//

import CocoaLumberjack

class JLogUtil {
    static func configure() {
        #if DEBUG || STAGE || RELEASE
        if let logger = DDTTYLogger.sharedInstance {
            DDLog.add(logger) // 允许在控制台输出日志
        }
        #endif
        DDLog.add(fileLogger) // 添加文件日志记录器
    }
    
    static let logFileManager = DDLogFileManagerDefault(logsDirectory: logsDirectory())
    static let fileLogger: DDFileLogger = {
        let logger = DDFileLogger(logFileManager: logFileManager)
        logger.rollingFrequency = 60 * 60 * 24 // 每天滚动
        logger.maximumFileSize = 1024 * 1024 * 5 // 每个日志文件最大5MB
        logger.doNotReuseLogFiles = true // 不重用日志文件
        return logger
    }()
    
    static func jLog<T>(_ message: T, file: String = #file, funcName: String = #function, lineNum: Int = #line) {
        let fileName = (file as NSString).lastPathComponent.removeSubstring(".swift")
        
        // 生成日志信息
        let logMessage = "[\(fileName)] \(message)"
        
        // 使用DDLogMessage记录日志
        DDLogInfo(logMessage)
    }
    
    // 获取日志文件存储路径
    private static func logsDirectory() -> String {
        let paths = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask) // 使用Library目录
        let logsDirectory = paths[0].appendingPathComponent("Logs")
        
        // 创建目录
        if !FileManager.default.fileExists(atPath: logsDirectory.path) {
            do {
                try FileManager.default.createDirectory(at: logsDirectory, withIntermediateDirectories: true, attributes: nil)
                print("Logs directory created at: \(logsDirectory.path)")
            } catch {
                print("Failed to create logs directory: \(error)")
            }
        } else {
            print("Logs directory already exists at: \(logsDirectory.path)")
        }
        
        return logsDirectory.path
    }
    
    // 自动清理旧日志文件
    static func cleanOldLogs() {
        let fileManager = FileManager.default
        guard let logFiles = try? fileManager.contentsOfDirectory(atPath: logsDirectory()) else { return }
        
        for file in logFiles {
            let filePath = (logsDirectory() as NSString).appendingPathComponent(file)
            if let attributes = try? fileManager.attributesOfItem(atPath: filePath),
               let creationDate = attributes[.creationDate] as? Date {
                let age = Date().timeIntervalSince(creationDate)
                // 删除超过7天的日志文件
                if age > 7 * 24 * 60 * 60 {
                    try? fileManager.removeItem(atPath: filePath)
                }
            }
        }
    }
}

// 方便外部调用的日志函数
func JLog<T>(_ message: T, file: String = #file, funcName: String = #function, lineNum: Int = #line) {
    JLogUtil.jLog(message, file: file, funcName: funcName, lineNum: lineNum)
}
