//
//  NSCoder_extension.swift
//  afcore
//
//  Created by Adam Fowler on 21/09/2018.
//  Copyright © 2018 Adam Fowler. All rights reserved.
//

import Foundation

extension NSCoder {

    public func decodeOptionalInteger(forKey key: String) -> Int? {
        if containsValue(forKey:key) {
            return decodeInteger(forKey:key)
        } else {
            return nil
        }
    }
    
    public func decodeOptionalFloat(forKey key: String) -> Float? {
        if containsValue(forKey:key) {
            return decodeFloat(forKey:key)
        } else {
            return nil
        }
    }
    
    public func decodeOptionalDouble(forKey key: String) -> Double? {
        if containsValue(forKey:key) {
            return decodeDouble(forKey:key)
        } else {
            return nil
        }
    }
    
}
