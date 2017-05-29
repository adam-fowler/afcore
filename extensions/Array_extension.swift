//
//  Array_extension.swift
//  afcore
//
//  Created by Adam Fowler on 29/05/2017.
//  Copyright © 2017 Adam Fowler. All rights reserved.
//

import Foundation

extension Array {
    
    /// Move array entry from one point to another
    /// - parameter at: index of array entry to move
    /// - parameter to: index in array to move to
    public mutating func move(at: Int, to: Int) {
        
        if at < to {
            
            // extract object and shift everything down until index to
            let temp = self[at]
            for index in (at...(to-1)) {
                self[index] = self[index+1];
            }
            self[to] = temp
            
        } else if (at > to){
            
            // extract object and shift everything down until index to
            let temp = self[at]
            for index in ((to+1)...at).reversed() {
                self[index] = self[index-1];
            }
            self[to] = temp
            
        }
    }
}
