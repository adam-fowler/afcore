//
//  assert.swift
//  debug
//
//  Created by Adam Fowler on 23/05/2017.
//  Copyright © 2017 Adam Fowler. All rights reserved.
//

import Foundation

public func nonfatal_assert(_ condition: @autoclosure () -> Bool, _ message: @autoclosure () -> String = "",
                     file: String = #file, line: Int = #line) {
    #if DEBUG
        if !condition() {
            let output : String = "Assert: \(file.components(separatedBy:"/").last ?? file):\(line): \(message())"
            print(output)
            if DebugHelper.isDebuggerAttached() {
                DebugHelper.break()
            }
        }
    #endif
}

public func verify(_ condition: @autoclosure () -> Bool, _ message: @autoclosure () -> String = "",
            file: String = #file, line: Int = #line) -> Bool {
    if !condition() {
        #if DEBUG
            let output : String = "Assert: \(file.components(separatedBy:"/").last ?? file):\(line): \(message())"
            print(output)
            if DebugHelper.isDebuggerAttached() {
                DebugHelper.break()
            }
        #endif
        return false
    }
    return true
}

public func fatal_assert(_ condition: @autoclosure () -> Bool, _ message: @autoclosure () -> String = "",
                     file: String = #file, line: Int = #line) {
    #if DEBUG
        if !condition() {
            print("Assert: \(file.components(separatedBy:"/").last ?? file):\(line): \(message())")
            DebugHelper.trap()
        }
    #endif
}

