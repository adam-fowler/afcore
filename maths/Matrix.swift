//
//  Matrix.swift
//  maths
//
//  Created by Adam Fowler on 18/04/2017.
//  Copyright © 2017 Adam Fowler. All rights reserved.
//

import Foundation

public class Matrix {
    public init(_ elements: [Vector]) {
        self.elements = elements
    }
    
    public init(xSize: Int, ySize: Int) {
        elements = Array(repeating:Vector(size: xSize), count:ySize)
    }
    
    init(_ left: Matrix, _ right: Matrix, operation: (Vector,Vector)->Vector) {
        assert(left.count == right.count)
        assert(left[0].count == right[0].count)
        
        elements = Array(repeating:Vector(size:left[0].count), count:left.count)
        for i in 0..<left.count {
            elements[i] = operation(left[i], right[i])
        }
    }
    
    public subscript(index:Int) -> Vector {
        get {
            return elements[index]
        }
    }

    public func row(_ index:Int) -> Vector {
        return elements[index]
    }
    
    public func column(_ index:Int) -> Vector {
        let column = Vector(size: count)
        for i in 0..<count {
            column[i] = elements[i][index]
        }
        return column
    }
    
    func operate(operation: (Vector)->Vector) {
        for i in 0..<count {
            elements[i] = operation(elements[i])
        }
    }
    
    func operate(_ right: Matrix, operation: (Vector,Vector)->Vector) {
        assert(count == right.count)
        for i in 0..<count {
            elements[i] = operation(elements[i], right[i])
        }
    }
    
    func operate(_ right: Vector, operation: (Vector,Vector)->Vector) {
        for i in 0..<count {
            elements[i] = operation(elements[i], right)
        }
    }
    
    public static func + (left: Matrix, right: Matrix) -> Matrix {
        return Matrix(left, right, operation:{a, b in return a+b})
    }
    
    public static func - (left: Matrix, right: Matrix) -> Matrix {
        return Matrix(left, right, operation:{a, b in return a-b})
    }
    
    public static func * (left:Matrix, right: Vector) -> Vector {
        assert(left[0].count == right.count)
        let result = Vector(size: left.count)
        for i in 0..<left.count {
            result[i] = Vector.Dot(left.row(i), right)
        }
        return result
    }
    
    public static func * (left:Vector, right: Matrix) -> Vector {
        assert(left.count == right.count)
        let result = Vector(size: right[0].count)
        for i in 0..<right[0].count {
            result[i] = Vector.Dot(left, right.column(i))
        }
        return result
    }
    
    public static func * (left:Matrix, right: Matrix) -> Matrix {
        assert(left[0].count == right.count)
        
        let result = Matrix(xSize: left.count, ySize: right[0].count)
        for i in 0..<left.count {
            for j in 0..<right[0].count {
                result[j][i] = Vector.Dot(left.row(i), right.column(j))
                print("Dot \(left.row(i)) and \(right.column(j)) = \(result[j][i])")
            }
        }
        return result
    }
    
    var elements : [Vector]
    var count : Int { get {return elements.count } }
}

extension Matrix  : CustomDebugStringConvertible {
    public var debugDescription: String {
        var description = "Matrix:("
        for i in 0..<count-1 {
            description += "\(elements[i]),\n"
        }
        description += "\(elements.last!))\n"
        return description
    }
}
