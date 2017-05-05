//
//  Queue.swift
//  generics
//
//  Created by Adam Fowler on 04/05/2017.
//  Copyright © 2017 Adam Fowler. All rights reserved.
//

/// class implementing a standard fifo queue
public class Queue<Element> : CustomDebugStringConvertible {
    
    /// init class
    /// - parameter count: Max size of queue
    public init(count: Int) {
        elements = Array<Element?>(repeating:nil, count:count)
        _tail = 0
        _head = 0
        wrap = false
    }
    
    /// push element onto tail of the queue
    /// - parameter element: element to push onto queue
    /// - returns: whether it was successful
    public func push(_ element : Element) -> Bool {
        if _tail == _head && wrap {
            return false
        }
        elements[_tail] = element
        _tail += 1
        if _tail == elements.count {
            wrap = true
            _tail = 0
        }
        return true
    }

    /// pop elements off the head of the queue
    /// - returns: head of queue. If queue is empty it returns nil
    public func pop() -> Element? {
        if _head == _tail && !wrap {
            return nil
        }
        let value = elements[_head]
        elements[_head] = nil
        _head += 1
        if _head == elements.count {
            wrap = false
            _head = 0
        }
        return value
    }
    
    /// return entry at the tail of the queue
    /// - returns: Element at tail of queue i.e. last element added. If queue is empty it returns nil
    public func tail() -> Element? {
        if _head == _tail && !wrap {
            return nil
        }
        var index = _tail - 1
        if index < 0 {
            index = elements.count - 1
        }
        return elements[index]
    }
    
    /// return entry at the head of the queue
    /// - returns: Element at head of queue i.e. the next element to be popped off the queue. If queue is empty it returns nil
    public func head() -> Element? {
        if _head == _tail && !wrap {
            return nil
        }
        return elements[_head]
    }
    
    public var debugDescription: String {
        var description = "["
        if _tail != _head || wrap {
            var index = _tail
            
            index -= 1
            if index < 0 {
                index = elements.count - 1
            }
            repeat {
                description += "\(elements[index]!), "
                index -= 1
                if index < 0 {
                    index = elements.count - 1
                }
                
            } while index != _head
            description += "\(elements[index]!)"
        }
        description += "]"
        return description
    }
    
    private var wrap : Bool
    private var _tail : Int
    private var _head : Int
    private var elements : [Element?]
}
