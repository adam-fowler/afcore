//
//  String_extension.swift
//  extensions
//
//  Created by Adam Fowler on 15/04/2017.
//  Copyright © 2017 Adam Fowler. All rights reserved.
//

import Foundation

extension String {
    
    /// Replace HTML encoding with ASCII equivalents
    /// - returns: ASCII string
    public func htmlDecode() -> String
    {
        var replacement = self.replacingOccurrences(of: "&amp;", with: "&")
        replacement = replacement.replacingOccurrences(of: "&quot;", with: "\"")
        replacement = replacement.replacingOccurrences(of: "&#x27;", with: "'")
        replacement = replacement.replacingOccurrences(of: "&#39;", with: "'")
        replacement = replacement.replacingOccurrences(of: "&#x92;", with: "'")
        replacement = replacement.replacingOccurrences(of: "&#x96;", with: "-")
        replacement = replacement.replacingOccurrences(of: "&lt;", with: "<")
        return replacement.replacingOccurrences(of: "&gt;", with: ">")
    }
    
    /// Replace ASCII characters with HTML encoded equivalents
    /// - returns: HTML encoded string
    public func htmlEncode() -> String {
        var replacement = self.replacingOccurrences(of: "&", with: "&amp;")
        replacement = replacement.replacingOccurrences(of: "\"", with: "&quot;")
        replacement = replacement.replacingOccurrences(of: "'", with: "&#x27;")
        replacement = replacement.replacingOccurrences(of: "<", with: "&lt;")
        return replacement.replacingOccurrences(of: ">", with: "&gt;")
    }

    // idea taken from https://medium.com/@marcosantadev/app-localization-tips-with-swift-4e9b2d9672c9
    public func localized(bundle: Bundle = .main, tableName: String = "general") -> String {
        return NSLocalizedString(self, tableName: tableName, value: "**\(self)**", comment: "")
    }
}
