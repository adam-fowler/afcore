//
// Atomic.swift
//
// system
//
//  Created by Adam Fowler on 24/10/2019.
//  Copyright © 2019 Adam Fowler. All rights reserved.
//
import Foundation

public struct Atomic<T> {
    private var _value: T
    private var lock = NSLock()

    public init(value: T) {
        _value = value
    }

    public var value: T {
        get {
            lock.lock()
            let value = _value
            lock.unlock()
            return value
        }
        set {
            lock.lock()
            _value = newValue
            lock.unlock()
        }
    }
}
