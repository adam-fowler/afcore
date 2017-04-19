//
//  mathsTests.swift
//  mathsTests
//
//  Created by Adam Fowler on 18/04/2017.
//  Copyright © 2017 Adam Fowler. All rights reserved.
//

import Foundation
import XCTest
@testable import maths

class mathsTests: XCTestCase {
    
    func testEquality() {
        let a = ([1,5,6,7])
        let b = ([1,5,6,7])
        let c = ([5,2,9,10])
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
    
    func testMagnitude() {
        let a = Vector([1,4,5,6,7])
        let mag = a.Magnitude()
        XCTAssert(mag == sqrt(1+16+25+36+49))
    }
    
    func testMatrixInverse() {
        let matrix = Matrix([Vector([2,4,10]),Vector([4,10,28]),Vector([10,28,80])])
        let vector = Vector([6,0,25])
        
        XCTAssert(vector * matrix * matrix.inverse() == vector)
    }
    
    func testPolynomialFit() {
        let polyFit = PolynomialFit(points: [Vector2d(x:0,y:1), Vector2d(x:1,y:6), Vector2d(x:2,y:17), Vector2d(x:3,y:34), Vector2d(x:4,y:57)])
        let v = polyFit.solve(order:4)
        XCTAssert(abs(v[0] - 1.0) < 0.000001 && abs(v[1] - 2.0) < 0.000001 && abs(v[2] - 3.0) < 0.000001 && abs(v[3]) < 0.000001 && abs(v[4]) < 0.000001)
    }
}
