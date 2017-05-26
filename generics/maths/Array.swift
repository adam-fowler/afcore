//
//  Array.swift
//  maths
//
//  Created by Adam Fowler on 18/04/2017.
//  Code taken from http://stackoverflow.com/questions/27812433/how-do-i-make-a-exact-duplicate-copy-of-an-array
//

import Foundation

protocol Copying {
    init(original: Self)
}

extension Copying {
    func copy() -> Self {
        return Self.init(original: self)
    }
}

extension Array where Element: Copying {
    func clone() -> Array {
        var copiedArray = Array<Element>()
        for element in self {
            copiedArray.append(element.copy())
        }
        return copiedArray
    }
}
