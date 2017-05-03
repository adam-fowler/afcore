//
//  CubicFit.swift
//  maths
//
//  Created by Adam Fowler on 18/04/2017.
//  Code based on this page https://rosettacode.org/wiki/Polynomial_regression
//

import Foundation

public class PolynomialFunction {

    // fit()
    // Find the coefficients of a polynomial function that approximates the graph that contains the list of points supplied
    public static func fit(xPoints: Vector, yPoints: Vector, order: Int) -> Vector {
        
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
        matrix[0][0] = Double(xPoints.count)
        for i in 0..<order+1 {
            for j in 0..<order+1 {
                if i + j != 0 {
                    matrix[j][i] = summedXPowers[i+j-1]
                }
            }
        }
        
        let inverse = matrix.inverse()
        return inverse! * Vector(summedXYPowers)
    }
    
    // compute()
    // Return polynomial result, given x
    public static func compute(coeffs: Vector, x: Double) -> Double {
        var power = 1.0
        var value = 0.0
        for i in 0..<coeffs.count {
            value += coeffs[i] * power
            power *= x
        }
        return value
    }
    
    // solveNewtonRaphson()
    // solve a polynomial equation f(x) = 0 using Newton Raphson method
    public static func solveNewtonRaphson(coeffs: Vector, initialValue: Double, threshold: Double) -> Double {
        var derivativeCoeffs : [Double] = coeffs.elements
        derivativeCoeffs.remove(at:0)
        for i in 0..<derivativeCoeffs.count {
            derivativeCoeffs[i] *= Double(i+1)
        }

        let derivative = Vector(derivativeCoeffs)
        var x = initialValue
        while(true) {
            let newX = x - compute(coeffs: coeffs, x: x) / compute(coeffs: derivative, x: x)
            if abs(newX - x) < threshold {
                break
            }
            x = newX
            print(x)
        }
        return x
    }
}

