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
    
    func dotProduct() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let a = Vector([1,4,5,6,7])
        let b = Vector([3,4,5,0,2])
        XCTAssert(Vector.Dot(a,b) == 58)
        //print(a.Magnitude())
    }
    
    func magnitude() {
        let a = Vector([1,4,5,6,7])
        let mag = a.Magnitude()
        XCTAssert(mag == 1)
    }
    
}
