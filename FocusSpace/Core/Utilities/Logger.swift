//
//  Logger.swift
//  FocusSpace
//
//  Created by Panachai Sulsaksakul on 10/18/25.
//

struct Logger {
    static func log(_ message: String, file: String = #file, line: Int = #line) {
        #if DEBUG
        print("[\(file.components(separatedBy: "/").last ?? ""):\(line)] \(message)")
        #endif
    }
}
