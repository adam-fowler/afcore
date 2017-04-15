//
//  CGPoint_extension.swift
//  Viewfinder
//
//  Created by Adam Fowler on 01/04/2017.
//  Copyright © 2017 Adam Fowler. All rights reserved.
//

import CoreGraphics

extension CGPoint {
    public init(size: CGSize) {
        x = size.width
        y = size.height
    }
    
    public static func + (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x:left.x + right.x, y:left.y + right.y)
    }
    
    public static func - (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x:left.x - right.x, y:left.y - right.y)
    }
    
    public static func * (left: CGFloat, right: CGPoint) -> CGPoint {
        return CGPoint(x:left * right.x, y:left * right.y)
    }
    
    public static func * (left: CGPoint, right: CGFloat) -> CGPoint {
        return CGPoint(x:left.x * right, y:left.y * right)
    }
    
    public static func / (left: CGPoint, right: CGFloat) -> CGPoint {
        return CGPoint(x:left.x / right, y:left.y / right)
    }
    
    public static func += (left: inout CGPoint, right: CGPoint) {
        left.x += right.x
        left.y += right.y
    }
    
    public static func -= (left: inout CGPoint, right: CGPoint) {
        left.x -= right.x
        left.y -= right.y
    }
    
    public static func *= (left: inout CGPoint, right: CGFloat) {
        left.x *= right
        left.y *= right
    }
    
    public static func /= (left: inout CGPoint, right: CGFloat) {
        left.x /= right
        left.y /= right
    }
    
    public static prefix func - (left: CGPoint) -> CGPoint {
        return CGPoint(x:-left.x, y:-left.y)
    }
    
    public func Magnitude() -> CGFloat {
        return CGFloat(sqrt(Float(x*x + y*y)))
    }
    
    public func unapplying(_ t: CGAffineTransform) -> CGPoint {
        let inverse = t.inverted()
        return self.applying(inverse)
    }
}
