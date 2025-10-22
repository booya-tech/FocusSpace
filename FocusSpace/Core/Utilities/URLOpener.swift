//
//  URLOpener.swift
//  FocusSpace
//
//  Created by Panachai Sulsaksakul on 10/20/25.
//
//  Helper for opening external URLs
//

import UIKit

enum URLOpener {
    /// Open GitHub repository
    static func openGitHub() {
        openURL(AppConstants.URLs.github)
    }
    
    /// Open privacy policy
    static func openPrivacyPolicy() {
        openURL(AppConstants.URLs.privacyPolicy)
    }
    
    /// Open terms of service
    static func openTermsOfService() {
        openURL(AppConstants.URLs.termsOfService)
    }
    
    /// Open any URL string
    static func openURL(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
}