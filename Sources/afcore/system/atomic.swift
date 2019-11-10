//
// Atomic.swift
//
// system
//
//  Created by Adam Fowler on 24/10/2019.
//  Ideas taken from https://www.vadimbulavin.com/atomic-properties/
//  Copyright © 2019 Adam Fowler. All rights reserved.
//
import Foundation

protocol Lock {
    func lock()
    func unlock()
}

extension NSLock: Lock {}

public struct Atomic<T> {
    private var _value: T
    private var lock = NSLock()

    public init(value: T) {
        _value = value
    }

    public var value: T {
        get {
            lock.lock()
            defer {
                lock.unlock()
            }
            let value = _value
            return value
        }
        set {
            lock.lock()
            defer {
                lock.unlock()
            }
            _value = newValue
        }
    }
    
    public mutating func exchange(_ newValue: T) -> T {
        lock.lock()
        defer {
            lock.unlock()
        }
        let oldValue = _value
        _value = newValue
        return oldValue
    }
}
