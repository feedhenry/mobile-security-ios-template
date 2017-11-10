//
//  Logger.swift
//  secure-ios-app
//
//  Created by Wei Li on 10/11/2017.
//  Copyright © 2017 Wei Li. All rights reserved.
//

import Foundation

enum LogLevel: String {
    case v = "[🔬]" //verbose
    case d = "[💬]" // debug
    case i = "[ℹ️]" //info
    case w = "[⚠️]" // warning
    case e = "[‼️]" //error
    case s = "[🔥]" //severe
}

class Logger {
    static var dateFormat = "yyyy-MM-dd hh:mm:ssSSS"
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }
    
    class func verbose(_ message: String) {
        Logger.log(message: message, level: .v)
    }
    
    class func debug(_ message: String) {
        Logger.log(message: message, level: .d)
    }
    
    class func info(_ message: String) {
        Logger.log(message: message, level: .i)
    }
    
    class func warn(_ message: String) {
        Logger.log(message: message, level: .w)
    }
    
    class func error(_ message: String) {
        Logger.log(message: message, level: .e)
    }
    
    class func severe(_ message: String) {
        Logger.log(message: message, level: .s)
    }
    
    class func log(message: String,
                   level: LogLevel,
                   fileName: String = #file,
                   line: Int = #line,
                   column: Int = #column,
                   funcName: String = #function) {
        
        #if DEBUG
            print("\(Date().toString()) \(level.rawValue)[\(sourceFileName(filePath: fileName))]:\(line) \(column) \(funcName) -> \(message)")
        #endif
    }
    
    private class func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
}

internal extension Date {
    func toString() -> String {
        return Logger.dateFormatter.string(from: self as Date)
    }
}
