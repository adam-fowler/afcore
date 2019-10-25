//
// Atomic.swift
//
// system
//
//  Created by Adam Fowler on 24/10/2019.
//  Copyright © 2019 Adam Fowler. All rights reserved.
//
import Foundation

protocol EmptyInitializer {
    init()
}

struct Atomic<T: EmptyInitializer> {
    private var _value: T
    private var lock = NSLock()

    init() {
        _value = T.init()
    }

    var value: T {
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

class B {
    init() {}
    let g = 1
}

let a = Atomic<B>()
a.value = B(g:2)
