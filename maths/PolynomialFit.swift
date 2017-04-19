//
//  CubicFit.swift
//  maths
//
//  Created by Adam Fowler on 18/04/2017.
//  Copyright © 2017 Adam Fowler. All rights reserved.
//

import Foundation

public class PolynomialFit {
    public init(points: [Vector2d]) {
        xPoints = Vector(points.map{$0.x})
        yPoints = Vector(points.map{$0.y})
    }
    
    public func solve(order: Int) -> Vector {
        assert(order < xPoints.count)
        var summedXPowers : [Double] = []
        var summedXYPowers : [Double] = []
        
        let xPowers = xPoints.copy()
        for _ in 1...order * 2 {
            summedXPowers.append(xPowers.Sum())
            xPowers.operate(xPoints, operation:{a,b in return a*b})
        }
        
        let xyPowers = xPoints.copy()
        summedXYPowers.append(yPoints.Sum())
        for _ in 0..<order {
            summedXYPowers.append(Vector(xyPowers, yPoints, operation:{a,b in return a*b}).Sum())
            xyPowers.operate(xPoints, operation:{a,b in return a*b})
        }

        let matrix = Matrix(xSize: order+1, ySize: order+1)
        matrix.set(0,0, Double(xPoints.count))
        for i in 0..<order+1 {
            for j in 0..<order+1 {
                if i + j != 0 {
                    matrix.set(i,j, summedXPowers[i+j-1])
                }
            }
        }
        
        let inverse = matrix.inverse()
        return inverse * Vector(summedXYPowers)
    }
    
    var xPoints : Vector
    var yPoints : Vector
}

