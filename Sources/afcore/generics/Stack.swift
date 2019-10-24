//
//  Stack.swift
//  generics
//
//  Created by Adam Fowler on 04/05/2017.
//  Copyright © 2017 Adam Fowler. All rights reserved.
//

/// class implementing a standard lifo queue
public class Stack<Element> : CustomDebugStringConvertible {

    /// init class
    /// - parameter count: Max size of stack
    public init(count: Int) {
        elements = Array<Element?>(repeating:nil, count:count)
        _top = 0
    }
    
    /// push element onto top of the stack
    /// - parameter element: element to push onto stack
    /// - returns: whether it was successful
    public func push(_ element : Element) -> Bool {
        if _top == elements.count {
            return false
        }
        elements[_top] = element
        _top += 1
        return true
    }
    
    /// pop elements off the top of the stack
    /// - returns: top of stack. If stack is empty it returns nil
    public func pop() -> Element? {
        if _top == 0 {
            return nil
        }
        _top -= 1
        let value = elements[_top]
        elements[_top] = nil
        return value
    }
    
    /// return element at top of stack without popping it
    /// - returns: element at top of stack. If stack is empty it returns nil
    public func top() -> Element? {
        if _top > 0 {
            return elements[_top - 1]
        }
        return nil
    }
    
    public var debugDescription: String {
        var description = "["
        if _top != 0 {
            var index = _top - 1
            repeat {
                description += "\(elements[index]!), "
                index -= 1
            } while index != 0
            description += "\(elements[0]!)"
        }
        description += "]"
        return description
    }
    
    private var _top : Int
    private var elements : [Element?]
}
