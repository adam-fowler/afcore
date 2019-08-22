//
//  assert.swift
//  debug
//
//  Created by Adam Fowler on 23/05/2017.
//  Copyright © 2017 Adam Fowler. All rights reserved.
//

import Foundation
import debug

/// A non fatal assert that allows you to continue in the debugger
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

/// Verify a condition. In debug builds if the condition fails a non fatal assert is thrown
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

/// A fatal assert that stops execution
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

/// Class that post messages plus information about where the messages are coming from, to a server.
/// Used by assert code above
public class ErrorRecorder {
    /// - parameters:
    ///     - url: url of web page to post messages to
    ///     - username: user login for the web page
    ///     - password: password for login to the web page
    public init(url : String, username : String, password : String){
        self.url = url
        self.username = username
        self.password = password
        self.enabled = true
    }

    /// Singleton
    public static var instance : ErrorRecorder?
    
    /// Send message to server along with extra information detailing where the message came from
    /// - parameters:
    ///     - message: Contents of message
    ///     - file: filename from where postMessage was called
    ///     - line: line number of code calling postMessage
    ///     - completion: closure called once message has been sent
    public func postMessage(_ message: String, file: String = #file, line: Int = #line, completion: @escaping ()->() = {}) {
        guard enabled == true else {return}
        
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        #if os(iOS)
        let identifier = UIDevice.current.identifierForVendor ?? UUID()
        let os = "\(UIDevice.current.systemName) \(UIDevice.current.systemVersion)"
        let type = UIDevice.current.systemType.rawValue
        #else
        let identifier = ProcessInfo.processInfo.globallyUniqueString
        let os = ProcessInfo.processInfo.operatingSystemVersionString
        let type = "Mac"
        #endif
        let postDictionary : [String:Any] = ["version":version, "os":os, "model":type, "uuid": identifier.description, "assert":message, "file":file, "line":line]
        let postData = try! JSONSerialization.data(withJSONObject: postDictionary, options: [])
        
        _ = Http.post(url:url, username:username, password:password, data: postData) { data, response, error in
            if let error = error {
                print(error)
            } else {
                if let response = response as? HTTPURLResponse {
                    if response.statusCode != 200 {
                        print("Http response is \(response.statusCode) : \(String(describing: response))")
                        self.enabled = false
                    }
                }
            }
            completion();
        }
    }
    
    var enabled : Bool
    var url : String
    var username : String
    var password : String
}
