//
//  CoreDataArray.swift
//  afcore
//
//  Created by Adam Fowler on 15/05/2018.
//  Copyright © 2018 Adam Fowler. All rights reserved.
//

import CoreData

/// ManagedObject class that only deletes the object it owns if it hasn't been referenced
public class ManagedObject<Type> where Type: NSManagedObject {
    public init(_ object : Type) {
        self._object = object
    }
    
    deinit {
        if referenced == false {
            if let managedContext = CoreData.getManagedContext() {
                managedContext.delete(_object)
                _ = CoreData.save()
            }
        }
    }
    public var object : Type { get { referenced = true; return _object} }
    private let _object : Type
    private var referenced = false
}

/// CoreData array
@available(macOS 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *)
public class CoreDataArray<Type> : CustomDebugStringConvertible where Type: NSManagedObject {
    public typealias Element = Type
    
    public init() {}

    public var debugDescription: String { return array.debugDescription }
    
    public subscript(position: Int) -> Element {
        return array[position]
    }
    
    public var first: Element? { get {return array.first}}
    public var last: Element? { get {return array.last}}

    public func load(sortDescriptors:[NSSortDescriptor] = []) {
        guard let managedContext = CoreData.getManagedContext() else { return }
        
        // Load array
        let fetchRequest : NSFetchRequest<Type> = Type.fetchRequest() as! NSFetchRequest<Type>
        fetchRequest.sortDescriptors = sortDescriptors
        
        do {
            array = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch data. \(error), \(error.userInfo)")
        }
    }
    
    public func create() -> Type? {
        guard let managedContext = CoreData.getManagedContext() else { return nil }
        let fetchRequest = Type.fetchRequest()
        guard let entity = fetchRequest.entity else {return nil}
        let entry = Type(entity: entity, insertInto: managedContext)
        return entry
    }
    
    public func append(_ newElement: Element) {
        array.append(newElement)
        _ = CoreData.save()
    }
    
    public func insert(_ newElement: Element, at: Int) {
        array.insert(newElement, at:at)
        _ = CoreData.save()
    }
    
    public func append(constructor:(inout Element)->()) {
        if var newElement = create() {
            constructor(&newElement)
            array.append(newElement)
            _ = CoreData.save()
        }
    }
    
    public func insert(constructor:(inout Element)->(), at: Int) {
        if var newElement = create() {
            constructor(&newElement)
            array.insert(newElement, at:at)
            _ = CoreData.save()
        }
    }
    
    @discardableResult public func remove(at: Int) -> ManagedObject<Element> {
        let tmp = array.remove(at:at)
        return ManagedObject<Element>(tmp)
    }
    
    public func removeAll() {
        if let managedContext = CoreData.getManagedContext() {
            for entry in array {
                managedContext.delete(entry)
            }
        }
        array.removeAll()
        _ = CoreData.save()
    }
    
    public func index(of element:Element) -> Int? {
        return array.firstIndex(of:element)
    }
    
    public func index(where predicate: (Element)->Bool) -> Int? {
        return array.firstIndex(where: predicate)
    }
    
    public var isEmpty : Bool {return array.isEmpty}
    public var count : Int {return array.count}
    
    private var array: [Type] = []
}
