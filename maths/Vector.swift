//
//  Vector.swift
//  maths
//
//  Created by Adam Fowler on 18/04/2017.
//  Copyright © 2017 Adam Fowler. All rights reserved.
//

import Foundation

public class Vector : Copying {
    public init(_ elements: [Double]) {
        self.elements = elements
    }
    
    public required init(original: Vector) {
        elements = []
        for element in original.elements {
            elements.append(element)
        }
    }
    
    public init(size: Int) {
        elements = Array(repeating:0.0, count:size)
    }
    
    init(_ left: Vector, _ right: Vector, operation: (Double,Double)->Double) {
        assert(left.count == right.count)
        
        elements = []
        elements.reserveCapacity(left.count)
        for i in 0..<left.count {
            elements.append(operation(left[i], right[i]))
        }
    }
    
    init(_ left: Double, _ right: Vector, operation: (Double,Double)->Double) {
        elements = []
        elements.reserveCapacity(right.count)
        for i in 0..<right.count {
            elements.append(operation(left, right[i]))
        }
    }
    
    init(_ left: Vector, _ right: Double, operation: (Double,Double)->Double) {
        elements = []
        elements.reserveCapacity(left.count)
        for i in 0..<left.count {
            elements.append(operation(left[i], right))
        }
    }
    
    init(_ left: Vector, operation: (Double)->Double) {
        elements = []
        elements.reserveCapacity(left.count)
        for i in 0..<left.count {
            elements.append(operation(left[i]))
        }
    }
    
    public subscript(index:Int) -> Double {
        get {
            return elements[index]
        }
        set(value) {
            elements[index] = value
        }
    }
    
    public func set(_ index : Int, _ value : Double) {
        elements[index] = value
    }
    
    func operate(operation: (Double)->Double) {
        for i in 0..<count {
            elements[i] = operation(elements[i])
        }
    }
    
    func operate(_ right: Vector, operation: (Double,Double)->Double) {
        assert(count == right.count)
        for i in 0..<count {
            elements[i] = operation(elements[i], right[i])
        }
    }
    
    func operate(_ right: Double, operation: (Double,Double)->Double) {
        for i in 0..<count {
            elements[i] = operation(elements[i], right)
        }
    }
    
    public static func + (left: Vector, right: Vector) -> Vector {
        return Vector(left, right, operation:{a, b in return a+b})
    }
    
    public static func - (left: Vector, right: Vector) -> Vector {
        return Vector(left, right, operation:{a, b in return a-b})
    }
    
    public static func * (left: Vector, right: Vector) -> Vector {
        return Vector(left, right, operation:{a, b in return a*b})
    }
    
    public static func * (left: Double, right: Vector) -> Vector {
        return Vector(left, right, operation:{a, b in return a*b})
    }
    
    public static func * (left: Vector, right: Double) -> Vector {
        return Vector(left, right, operation:{a, b in return a*b})
    }
    
    public static func / (left: Vector, right: Double) -> Vector {
        return Vector(left, right, operation:{a, b in return a/b})
    }
    
    public static func += (left: inout Vector, right: Vector) {
        left.operate(right, operation:{a, b in return a+b})
    }
    
    public static func -= (left: inout Vector, right: Vector) {
        left.operate(right, operation:{a, b in return a-b})
    }
    
    public static func *= (left: inout Vector, right: Double) {
        left.operate(right, operation:{a, b in return a*b})
    }
    
    public static func /= (left: inout Vector, right: Double) {
        left.operate(right, operation:{a, b in return a/b})
    }
    
    public static prefix func - (left: Vector) -> Vector {
        return Vector(left, operation:{a in return -a})
    }
    
    public static func == (left: Vector, right: Vector) -> Bool {
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
    
    public static func != (left: Vector, right: Vector) -> Bool {
        return !(left == right)
    }
    
    public func Sum() -> Double {
        var value = elements[0]
        for i in 1..<count {
            value += elements[i]
        }
        return value
    }
    
    public static func Dot(_ left: Vector, _ right: Vector) -> Double {
        let dot = left * right
        return dot.Sum()
    }
    
    public func Magnitude() -> Double {
        let mag = Vector(self, operation:{a in return a*a})
        return sqrt(mag.Sum())
    }

    private(set) var elements : [Double]
    public var count : Int { get {return elements.count } }
    
}

extension Vector : CustomDebugStringConvertible {
    public var debugDescription: String {
        var description = "["
        for i in 0..<count-1 {
            description += "\(elements[i].debugDescription),"
        }
        description += "\(elements.last!.debugDescription)]"
        return description
    }
}
