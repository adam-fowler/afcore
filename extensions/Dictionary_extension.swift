//
//  Dictionary_extension.swift
//  afcore
//
//  Created by Adam Fowler on 07/12/2018.
//  Copyright © 2018 Adam Fowler. All rights reserved.
//

import Foundation

extension Dictionary where Key == String {
    /// subscript element as if it is an array
    subscript(index:Int) -> Dictionary.Element {
        get {
            return self[keys.index(startIndex, offsetBy: index)]
        }
    }
    
    func intIndex(key: String) -> Int? {
        guard let index = index(forKey: key) else {return nil}
        return keys.distance(from: startIndex, to: index)
    }
}

