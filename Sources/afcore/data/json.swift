//
//  json.swift
//  afcore
//
//  Created by Adam Fowler on 30/05/2017.
//  Copyright © 2017 Adam Fowler. All rights reserved.
//
//  Initialise JsonParser with json data - let json = JsonParser(data:data)
//  access dictionary elements as follows - json["element"]
//  access array elements as follows - json[2]
//  chain together access - json[1]["element"]["name"]
//  access element as type - json[1].integer;json[3].string etc
//

import Foundation

/// Element within Json tree used by JsonParser
public class JsonEntry {
    
    init(_ entry: Any?) {
        self.entry = entry
    }
    
    /// return if element exists
    public var exists : Bool {
        get {return entry != nil}
    }
    
    /// return if element exists
    public var any : Any? {
        get {return entry}
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
    
    /// return element as data
    public var data : Data? {
        get { return string?.data(using:.utf8) }
    }
    
    /// return element as a dictionary
    public var dictionary : [String:Any]? {
        get { return entry as? [String:Any] }
    }
    
    /// return element as an array
    public var array : [Any]? {
        get { return entry as? [Any] }
    }
    
    /// return number of entries in array if element is an array
    public var arrayCount : Int {
        get { return (entry as? [Any])?.count ?? 0 }
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

/// Class for parsing Json data. Can either be initialised with raw data, or a ready made dictionary.
/// api takes inspiration from SwiftyJson but code is a lot smaller and simpler.
///  Initialise JsonParser with json data - let json = JsonParser(data:data).
///  Access dictionary elements as follows - json["element"].
///  Access array elements as follows - json[2].
///  Chain together access - json[1]["element"]["name"].
///  Access element as type - json[1].integer;json[3].string etc.
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

