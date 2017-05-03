//
//  VectorGeneric.swift
//  maths
//
//  Created by Adam Fowler on 20/04/2017.
//  Copyright © 2017 Adam Fowler. All rights reserved.
//

import Foundation

import Foundation

public protocol VectorElement : CustomDebugStringConvertible {
    static var zero : Self { get }
    static func + (left: Self, right: Self) -> Self
    static func - (left: Self, right: Self) -> Self
    static func * (left: Self, right: Self) -> Self
    static func / (left: Self, right: Self) -> Self
    static func += (left: inout Self, right: Self)
    static func -= (left: inout Self, right: Self)
    static func *= (left: inout Self, right: Self)
    static func /= (left: inout Self, right: Self)
    static prefix func - (left: Self) -> Self
    static func == (left: Self, right: Self) -> Bool
    static func != (left: Self, right: Self) -> Bool
}

extension Double : VectorElement {
    public static var zero : Double { get {return 0.0}}
}

extension Float : VectorElement {
    public static var zero : Float { get {return 0.0}}
}

public class VectorGeneric<T:VectorElement> : Copying, CustomDebugStringConvertible {
    public init(_ elements: [T]) {
        self.elements = elements
    }
    
    public required init(original: VectorGeneric) {
        elements = []
        for element in original.elements {
            elements.append(element)
        }
    }
    
    public init(size: Int) {
        elements = Array(repeating:T.zero, count:size)
    }
    
    init(_ left: VectorGeneric, _ right: VectorGeneric, operation: (T,T)->T) {
        assert(left.count == right.count)
        
        elements = []
        elements.reserveCapacity(left.count)
        for i in 0..<left.count {
            elements.append(operation(left[i], right[i]))
        }
    }
    
    init(_ left: T, _ right: VectorGeneric, operation: (T,T)->T) {
        elements = []
        elements.reserveCapacity(right.count)
        for i in 0..<right.count {
            elements.append(operation(left, right[i]))
        }
    }
    
    init(_ left: VectorGeneric, _ right: T, operation: (T,T)->T) {
        elements = []
        elements.reserveCapacity(left.count)
        for i in 0..<left.count {
            elements.append(operation(left[i], right))
        }
    }
    
    init(_ left: VectorGeneric, operation: (T)->T) {
        elements = []
        elements.reserveCapacity(left.count)
        for i in 0..<left.count {
            elements.append(operation(left[i]))
        }
    }
    
    public subscript(index:Int) -> T {
        get {
            return elements[index]
        }
        set(value) {
            elements[index] = value
        }
    }
    
    public func set(_ index : Int, _ value : T) {
        elements[index] = value
    }
    
    func operate(operation: (T)->T) {
        for i in 0..<count {
            elements[i] = operation(elements[i])
        }
    }
    
    func operate(_ right: VectorGeneric, operation: (T,T)->T) {
        assert(count == right.count)
        for i in 0..<count {
            elements[i] = operation(elements[i], right[i])
        }
    }
    
    func operate(_ right: T, operation: (T,T)->T) {
        for i in 0..<count {
            elements[i] = operation(elements[i], right)
        }
    }
    
    public static func + (left: VectorGeneric, right: VectorGeneric) -> VectorGeneric {
        return VectorGeneric(left, right, operation:{a, b in return a+b})
    }
    
    public static func - (left: VectorGeneric, right: VectorGeneric) -> VectorGeneric {
        return VectorGeneric(left, right, operation:{a, b in return a-b})
    }
    
    public static func * (left: VectorGeneric, right: VectorGeneric) -> VectorGeneric {
        return VectorGeneric(left, right, operation:{a, b in return a*b})
    }
    
    public static func * (left: T, right: VectorGeneric) -> VectorGeneric {
        return VectorGeneric(left, right, operation:{a, b in return a*b})
    }
    
    public static func * (left: VectorGeneric, right: T) -> VectorGeneric {
        return VectorGeneric(left, right, operation:{a, b in return a*b})
    }
    
    public static func / (left: VectorGeneric, right: T) -> VectorGeneric {
        return VectorGeneric(left, right, operation:{a, b in return a/b})
    }
    
    public static func += (left: inout VectorGeneric, right: VectorGeneric) {
        left.operate(right, operation:{a, b in return a+b})
    }
    
    public static func -= (left: inout VectorGeneric, right: VectorGeneric) {
        left.operate(right, operation:{a, b in return a-b})
    }
    
    public static func *= (left: inout VectorGeneric, right: T) {
        left.operate(right, operation:{a, b in return a*b})
    }
    
    public static func /= (left: inout VectorGeneric, right: T) {
        left.operate(right, operation:{a, b in return a/b})
    }
    
    public static prefix func - (left: VectorGeneric) -> VectorGeneric {
        return VectorGeneric(left, operation:{a in return -a})
    }
    
    public static func == (left: VectorGeneric, right: VectorGeneric) -> Bool {
        if left.count != right.count {
            return false
        }
        for i in 0..<left.count {
            if left.elements[i] != right.elements[i] {
                return false
            }
        }
        return true
    }
    
    public static func != (left: VectorGeneric, right: VectorGeneric) -> Bool {
        return !(left == right)
    }
    
    public func Sum() -> T {
        var value = elements[0]
        for i in 1..<count {
            value += elements[i]
        }
        return value
    }
    
    public static func Dot(_ left: VectorGeneric, _ right: VectorGeneric) -> T {
        let dot = VectorGeneric(left, right, operation:{a,b in return a*b})
        return dot.Sum()
    }
    
    public var debugDescription: String {
        var description = "["
        for i in 0..<count-1 {
            description += "\(elements[i].debugDescription),"
        }
        description += "\(elements.last!.debugDescription)]"
        return description
    }
    
    private(set) var elements : [T]
    public var count : Int { get {return elements.count } }
    
}

