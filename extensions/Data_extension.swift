//
//  Data_extension.swift
//  extensions
//
//  Created by Adam Fowler on 02/05/2017.
//  Code from http://stackoverflow.com/questions/39075043/how-to-convert-data-to-hex-string-in-swift
//

import Foundation

extension Data {
    public func hexEncodedString() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}
