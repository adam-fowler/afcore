//
//  mathsTests.swift
//  mathsTests
//
//  Created by Adam Fowler on 18/04/2017.
//  Copyright © 2017 Adam Fowler. All rights reserved.
//

import Foundation
import XCTest
@testable import afcore 

class mathsTests: XCTestCase {
    
    func testEquality() {
        let a = Vector([1,5,6,7])
        let b = Vector([1,5,6,7])
        let c = Vector([5,2,9,10])
        XCTAssert(a == b && a != c)
    }
    
    func testDotProduct() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let a = Vector([1,4,5,6,7])
        let b = Vector([3,4,5,0,2])
        XCTAssert(Vector.Dot(a,b) == 58)
        //print(a.Magnitude())
    }
    
    func testMatrixInverse() {
        let matrix = Matrix([Vector([2,4,10]),Vector([4,10,28]),Vector([10,28,80])])
        let vector = Vector([6,0,25])
        
        XCTAssert(vector * matrix * matrix.inverse()! == vector)
    }

    func testPolynomialSolve() {
        let v = PolynomialFunction.compute(coeffs: Vector([0,1,5,0.5,4]), x:2)
        XCTAssert(v == 90.0)
    }
    
    func testPolynomialFit() {
        let v = PolynomialFunction.fit(xPoints: Vector([0,1,2,3,4]), yPoints:Vector([1,6,17,34,57]), order:4)
        
        XCTAssert(abs(v[0] - 1.0) < 0.000001 && abs(v[1] - 2.0) < 0.000001 && abs(v[2] - 3.0) < 0.000001 && abs(v[3]) < 0.000001 && abs(v[4]) < 0.000001)
    }
    
    func testPolynomialNewtonRaphson() {
        let threshold = 0.001
        for i in 1...5 {
            var coeffs = Vector([-2,1,5,0.5,4])
            var x = Double(i)
            let y = PolynomialFunction.compute(coeffs: coeffs, x: x)
            coeffs[0] -= y
            let x2 = PolynomialFunction.solveNewtonRaphson(coeffs: Vector([-2-y,1,5,0.5,4]), initialValue:0, threshold:threshold)
            XCTAssert(abs(x - x2) < threshold)
        }
    }
}
