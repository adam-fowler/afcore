//
//  coredata.swift
//  afcore
//
//  Created by Adam Fowler on 15/05/2018.
//  Copyright © 2018 Adam Fowler. All rights reserved.
//

import CoreData

@available(macOS 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *)
public class CoreData {

    public class func getManagedContext() -> NSManagedObjectContext? {
        return persistentContainer.viewContext
    }

    public class func beginSave() {
        batchSave = true
    }
    
    @discardableResult public class func save() -> Bool {
        if batchSave { return true }
        
        guard let managedContext = getManagedContext() else { return false}
        do {
            try managedContext.save()
            return true
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return false
        }
    }
    
    @discardableResult public class func endSave() -> Bool {
        batchSave = false
        return save()
    }
    
    public class func getSingleObject(_ name : String, create : Bool) -> NSManagedObject? {
        guard let managedContext = CoreData.getManagedContext() else { return nil }
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: name)
        // only want one config object
        fetchRequest.fetchLimit = 1
        
        do {
            let objects = try managedContext.fetch(fetchRequest)
            if objects.count > 0 {
                return objects[0]
            } else if create {
                if let entity = NSEntityDescription.entity(forEntityName: name, in: managedContext) {
                    return NSManagedObject(entity: entity, insertInto: managedContext)
                }
            }
        } catch let error as NSError {
            print("Could not fetch data. \(error), \(error.userInfo)")
        }
        return nil
    }
    
    // MARK: - Core Data stack
    
    public static var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        
        let container = NSPersistentContainer(name: "Viewfinder")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                NotificationCenter.default.post(name: ViewFinderController.errorMessageNotification, object: nil, userInfo: [ViewFinderController.errorMessage : "There was an issue loading application data. Menus have been reverted to default and application data will not be saved"])
                disableCoreData = true
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                //fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    public class func saveContext () {
        let context = persistentContainer.viewContext
        if disableCoreData == false {
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    // not sure I need to do anything this is called on application shutdown
                    NotificationCenter.default.post(name: errorMessageNotification, object: nil, userInfo: [errorMessage : "There was an issue saving application data. Application data will not be saved from this point on. Please restart the application"])
                     self.disableCoreData = true
                    
                    //let nserror = error as NSError
                    //fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
    }

    static var batchSave = false
    static var disableCoreData = false
    public static let errorMessageNotification = NSNotification.Name(rawValue: "CoreData_ErrorMessage")
    public static let errorMessage = "errorMessage"
}
