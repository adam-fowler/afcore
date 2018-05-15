//
//  CoreDataArray.swift
//  afcore
//
//  Created by Adam Fowler on 15/05/2018.
//  Copyright © 2018 Adam Fowler. All rights reserved.
//

import CoreData

public class CoreDataArray<Type> where Type:NSManagedObject {
    public typealias Element = Type
    
    public init() {}

    public subscript(position: Int) -> Element {
        return array[position]
    }
    
    public func load() {
        guard let managedContext = CoreData.getManagedContext() else { return }
        
        // Load array
        let fetchRequest : NSFetchRequest<Type> = Type.fetchRequest() as! NSFetchRequest<Type>
        
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
    
    public func remove(at: Int) {
        guard let managedContext = CoreData.getManagedContext() else { return }
        managedContext.delete(array[at])
        array.remove(at:at)
        _ = CoreData.save()
    }
    
    public func removeAll() {
        guard let managedContext = CoreData.getManagedContext() else { return }
        for entry in array {
            managedContext.delete(entry)
        }
        array.removeAll()
        _ = CoreData.save()
    }
    
    public func index(of element:Element) -> Int? {
        return array.index(of:element)
    }
    
    public func index(where predicate: (Element)->Bool) -> Int? {
        return array.index(where: predicate)
    }
    
    public var isEmpty : Bool {return array.isEmpty}
    public var count : Int {return array.count}
    
    private var array: [Type] = []
}
