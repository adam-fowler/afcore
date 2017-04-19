//
//  Vector2d.swift
//  maths
//
//  Created by Adam Fowler on 18/04/2017.
//  Copyright © 2017 Adam Fowler. All rights reserved.
//

import Foundation

public class Vector2d {
    public init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }

    public static func + (left: Vector2d, right: Vector2d) -> Vector2d {
        return Vector2d(x:left.x + right.x, y:left.y + right.y)
    }
    
    public static func - (left: Vector2d, right: Vector2d) -> Vector2d {
        return Vector2d(x:left.x - right.x, y:left.y - right.y)
    }
    
    public static func * (left: Double, right: Vector2d) -> Vector2d {
        return Vector2d(x:left * right.x, y:left * right.y)
    }
    
    public static func * (left: Vector2d, right: Double) -> Vector2d {
        return Vector2d(x:left.x * right, y:left.y * right)
    }
    
    public static func / (left: Vector2d, right: Double) -> Vector2d {
        return Vector2d(x:left.x / right, y:left.y / right)
    }
    
    public static func += (left: inout Vector2d, right: Vector2d) {
        left.x += right.x
        left.y += right.y
    }
    
    public static func -= (left: inout Vector2d, right: Vector2d) {
        left.x -= right.x
        left.y -= right.y
    }
    
    public static func *= (left: inout Vector2d, right: Double) {
        left.x *= right
        left.y *= right
    }
    
    public static func /= (left: inout Vector2d, right: Double) {
        left.x /= right
        left.y /= right
    }
    
    public static prefix func - (left: Vector2d) -> Vector2d {
        return Vector2d(x:-left.x, y:-left.y)
    }
    
    public func Magnitude() -> Double {
        return sqrt(x*x + y*y)
    }
    

    var x : Double
    var y : Double
}
