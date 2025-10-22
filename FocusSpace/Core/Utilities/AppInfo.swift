//
//  AppInfo.swift
//  FocusSpace
//
//  Created by Panachai Sulsaksakul on 10/20/25.
//
//  App version and build information
//

import Foundation

enum AppInfo {
    /// App version (e.g., "1.0")
    static var version: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }
    
    /// Build number (e.g., "1.0.7")
    static var build: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }
    
    /// Full version string (e.g., "1.0 (1.0.7)")
    static var fullVersion: String {
        "\(version) (\(build))"
    }
    
    /// App name
    static var appName: String {
        Bundle.main.infoDictionary?["CFBundleName"] as? String ?? "FocusSpace"
    }
    
    /// Bundle identifier
    static var bundleIdentifier: String {
        Bundle.main.bundleIdentifier ?? "com.boopannachai.FocusSpace"
    }
}