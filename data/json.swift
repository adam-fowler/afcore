//
//  json.swift
//  afcore
//
//  Created by Adam Fowler on 30/05/2017.
//  Copyright © 2017 Adam Fowler. All rights reserved.
//

import Foundation

/// Element within Json tree used by JsonParser
public class JsonEntry {
    
    init(_ entry: Any?) {
        self.entry = entry
    }
    
    /// return element as an integer
    public var integer : Int? {
        get { return entry as? Int }
    }
    
    /// return element as a float
    public var float : Float? {
        get { return entry as? Float }
    }
    
    /// return element as a double
    public var double : Double? {
        get { return entry as? Double }
    }
    
    /// return element as a bool
    public var bool : Bool? {
        get { return entry as? Bool }
    }
    
    /// return element as a string
    public var string : String? {
        get { return entry as? String }
    }
    
    /// return element as a dictionary
    public var dictionary : [String:Any]? {
        get { return entry as? [String:Any] }
    }
    
    /// return element as an array
    public var array : [Any]? {
        get { return entry as? [Any] }
    }
    
    /// subscript element as if it is an array
    public subscript(index:Int) -> JsonEntry {
        get {
            return JsonEntry((entry as? [Any])?[index])
        }
    }
    
    /// subscript element as if it is a dictionary
    public subscript(key:String) -> JsonEntry {
        get {
            return JsonEntry((entry as? [String:Any])?[key])
        }
    }
    
    let entry : Any?
}

/// Class for parsing Json data. Can either be initialised with raw data, or a ready made dictionary
/// api takes inspiration from SwiftyJson but code is a lot smaller and simpler
public class JsonParser : JsonEntry {
    
    /// Create a foundation object from json data and use that to initialise the parser
    /// - parameter with: json data
    public init(data:Data) {
        do {
            try super.init(JSONSerialization.jsonObject(with:data))
        } catch {
            super.init(nil)
        }
    }

    /// Initialise parser with a foundation object
    /// - parameter with: object
    public init(object:Any?) {
        super.init(object)
    }
}

// Add debug strings to JsonEntry
extension JsonEntry : CustomStringConvertible, CustomDebugStringConvertible {
    
    public var description: String {
        if let entry = self.entry {
            return "JsonEntry: \(String(describing: entry))"
        } else {
            return "JsonEntry: nil"
        }
    }
    
    public var debugDescription: String {
        return description
    }
}

