//
//  Matrix.swift
//  maths
//
//  Created by Adam Fowler on 18/04/2017.
//  Copyright © 2017 Adam Fowler. All rights reserved.
//

import Foundation

public class Matrix : Copying {
    public init(_ elements: [Vector]) {
        self.elements = elements
    }
    
    public required init(original: Matrix) {
        elements = []
        elements.reserveCapacity(original.count)
        for element in original.elements {
            elements.append(element.copy())
        }
    }
    
    public init(xSize: Int, ySize: Int) {
        elements = []
        elements.reserveCapacity(ySize)
        for _ in 1...ySize {
            elements.append(Vector(size: xSize))
        }
    }
    
    init(_ left: Matrix, _ right: Matrix, operation: (Vector,Vector)->Vector) {
        assert(left.count == right.count)
        assert(left[0].count == right[0].count)
        
        elements = []//Array(repeating:Vector(size:left[0].count), count:left.count)
        elements.reserveCapacity(left.count)
        for i in 0..<left.count {
            elements.append(operation(left[i], right[i]))
        }
    }
    
    init(_ left: Double, _ right: Matrix, operation: (Double,Vector)->Vector) {
        elements = []
        elements.reserveCapacity(right.count)
        for i in 0..<right.count {
            elements.append(operation(left, right[i]))
        }
    }
    
    init(_ left: Matrix, _ right: Double, operation: (Vector,Double)->Vector) {
        elements = []
        elements.reserveCapacity(left.count)
        for i in 0..<left.count {
            elements.append(operation(left[i], right))
        }
    }
    
    public subscript(index:Int) -> Vector {
        get {
            return elements[index]
        }
        set(value) {
            elements[index] = value
        }
    }

    public func set(_ xIndex : Int, _ yIndex : Int, _ value : Double) {
        elements[yIndex].set(xIndex, value)
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
    
    public static func * (left: Matrix, right: Double) -> Matrix {
        return Matrix(left, right, operation:{a, b in return a*b})
    }
    
    public static func * (left: Double, right: Matrix) -> Matrix {
        return Matrix(left, right, operation:{a, b in return a*b})
    }
    
    public static func / (left: Matrix, right: Double) -> Matrix {
        return Matrix(left, right, operation:{a, b in return a/b})
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
            }
        }
        return result
    }
    
    public func inverse() -> Matrix? {
        // got this from https://www.cs.rochester.edu/~brown/Crypto/assts/projects/adj.html
        let d = determinant()
        if d == 0.0 {
            return nil
        }
        return adjoint() / determinant()
    }
    
    public func determinant() -> Double {
        assert(elements[0].count == count)
        var d = 0.0
        /*
         Recursive definition of determinate using expansion by minors.
         */
        if count == 1 { /* Shouldn't get used */
            d = self[0][0];
        } else if count == 2 {
            d = self[0][0] * self[1][1] - self[1][0] * self[0][1];
        } else {
            for j1 in 0..<count {
                let m = Matrix(xSize: count-1, ySize: count-1)
                
                for i in 1..<count {
                    var j2 = 0
                    for j in 0..<count {
                        if (j == j1) { continue }
                        m[i-1][j2] = self[i][j]
                        j2 += 1
                    }
                }
                d += pow(-1.0,Double(j1)+2.0) * self[0][j1] * m.determinant()
            }
        }
        return d
    }
    
    public func adjoint() -> Matrix {
        assert(elements[0].count == count)
        let b = Matrix(xSize: count, ySize: count)
        let c = Matrix(xSize: count-1, ySize: count-1)
        
        for j in 0..<count {
            for i in 0..<count {
                
                /* Form the adjoint a_ij */
                var i1 = 0
                for ii in 0..<count {
                    if ii == i { continue }
                    var j1 = 0;
                    for jj in 0..<count  {
                        if jj == j { continue }
                        c[i1][j1] = self[ii][jj]
                        j1 += 1;
                    }
                    i1 += 1;
                }
                
                /* Calculate the determinate */
                let d = c.determinant();
                
                /* Fill in the elements of the cofactor */
                b[j][i] = pow(-1.0,Double(i+j)+2.0) * d
            }
        }
        return b
    }
    
    public func transpose() -> Matrix {
        assert(elements[0].count == count)
        var rows : [Vector] = []
        rows.reserveCapacity(count)
        for i in 0..<count {
            rows.append(column(i))
        }
        return Matrix(rows)
    }
    
    var elements : [Vector]
    var count : Int { get {return elements.count } }
}

extension Matrix  : CustomDebugStringConvertible {
    public var debugDescription: String {
        var description = "["
        for i in 0..<count-1 {
            description += "\(elements[i]),\n"
        }
        description += "\(elements.last!)]\n"
        return description
    }
}

