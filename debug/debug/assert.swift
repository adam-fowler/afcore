//
//  assert.swift
//  debug
//
//  Created by Adam Fowler on 23/05/2017.
//  Copyright © 2017 Adam Fowler. All rights reserved.
//

import Foundation
import UIKit

func nonfatal_assert(_ condition: @autoclosure () -> Bool, _ message: @autoclosure () -> String = "",
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

func fatal_assert(_ condition: @autoclosure () -> Bool, _ message: @autoclosure () -> String = "",
                     file: String = #file, line: Int = #line) {
    #if DEBUG
        if !condition() {
            print("Assert: \(file.components(separatedBy:"/").last ?? file):\(line): \(message())")
            DebugHelper.trap()
        }
    #endif
}

