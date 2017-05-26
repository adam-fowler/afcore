//
//  assert.swift
//  debug
//
//  Created by Adam Fowler on 23/05/2017.
//  Copyright © 2017 Adam Fowler. All rights reserved.
//

import Foundation
import data
import UIKit
import extensions

public func nonfatal_assert(_ condition: @autoclosure () -> Bool, _ message: @autoclosure () -> String = "",
                     file: String = #file, line: Int = #line) {
    #if DEBUG
        if !condition() {
            let filename = file.components(separatedBy:"/").last ?? file
            let output : String = "Assert: \(filename):\(line): \(message())"
            print(output)
            if DebugHelper.isDebuggerAttached() {
                DebugHelper.break()
            } else {
                ErrorRecorder.instance?.postMessage("Assert: \(message())", file: filename, line: line);
            }
        }
    #endif
}

public func verify(_ condition: @autoclosure () -> Bool, _ message: @autoclosure () -> String = "",
            file: String = #file, line: Int = #line) -> Bool {
    if !condition() {
        #if DEBUG
            let filename = file.components(separatedBy:"/").last ?? file
            let output : String = "Verify: \(filename):\(line): \(message())"
            print(output)
            if DebugHelper.isDebuggerAttached() {
                DebugHelper.break()
            } else {
                ErrorRecorder.instance?.postMessage("Verify: \(message())", file: filename, line: line);
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
            let filename = file.components(separatedBy:"/").last ?? file
            print("Assert: \(filename):\(line): \(message())")
            if !DebugHelper.isDebuggerAttached() {
                var finished = false
                ErrorRecorder.instance?.postMessage("Assert: \(message())", file: filename, line: line) { finished = true };
                while !finished {
                    sleep(1)
                }
            }
            DebugHelper.trap()
        }
    #endif
}

//
//
//  Class that post messages plus information about where the messages are coming from, to a web page. Used by assert code above
//
public class ErrorRecorder {
    public init(url : String, username : String, password : String){
        self.url = url
        self.username = username
        self.password = password
        self.enabled = true
    }

    public static var instance : ErrorRecorder?
    
    public func postMessage(_ message: String, file: String = #file, line: Int = #line, completion: @escaping ()->() = {}) {
        guard enabled == true else {return}
        
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let identifier = UIDevice.current.identifierForVendor ?? UUID()
        let ios = UIDevice.current.systemName
        let iosVersion = UIDevice.current.systemVersion
        let type = UIDevice.current.systemType.rawValue
        let postDictionary : [String:Any] = ["version":version, "ios":"\(ios) \(iosVersion)", "model":type, "uuid": identifier.description, "assert":message, "file":file, "line":line]
        let postData = try! JSONSerialization.data(withJSONObject: postDictionary, options: [])
        
        Http.post(url:url, username:username, password:password, data: postData) { data, response, error in
            if let error = error {
                print(error)
            } else if let data = data {
                do {
                    let object = try JSONSerialization.jsonObject(with: data, options: [])
                    if let dictionary = object as? NSDictionary {
                        if let error = dictionary["error"]  as? NSDictionary {
                            if let code = error["code"] as? Int {
                                if code != 200 {
                                    print(dictionary);
                                    self.enabled = false
                                }
                            }
                        }
                    }
                } catch {}
            }
            completion();
        }
    }
    
    var enabled : Bool
    var url : String
    var username : String
    var password : String
}
