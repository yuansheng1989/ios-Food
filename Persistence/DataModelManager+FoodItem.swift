//
//  DataModelManager+FoodItem.swift
//  Purpose - Properties and methods for a specific entity in the app's data model
//

import CoreData

extension DataModelManager {
    
    // Methods included:
    // Count all or some
    // Fetch all
    // Fetch some
    // Fetch one by object identifier
    // Fetch one by matching another attribute
    // Create new item
    // Delete item
    // Delete all items
    
    // Count all (nil predicate) or some (non-nil configured predicate)
    func foodItem_Count(withPredicate: NSPredicate) -> Int {
        
        let fetchRequest: NSFetchRequest<FoodItem> = FoodItem.fetchRequest()
        fetchRequest.predicate = withPredicate
        
        do {
            let count = try ds_context.count(for: fetchRequest)
            return count
        } catch let error {
            print(error.localizedDescription)
        }
        return 0
    }
    
    // Fetch all
    func foodItem_GetAll() -> [FoodItem]? {
        return foodItem_GetSome(withPredicate: nil)
    }
    
    // Fetch some
    func foodItem_GetSome(withPredicate: NSPredicate?) -> [FoodItem]? {
        
        let fetchRequest: NSFetchRequest<FoodItem> = FoodItem.fetchRequest()
        fetchRequest.predicate = withPredicate
        
        // Optional, configure one or more sort descriptors here
        //fetchRequest.sortDescriptors?.append(NSSortDescriptor(key: "name", ascending: true))
        //fetchRequest.sortDescriptors?.append(NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:))))
        
        do {
            let results = try ds_context.fetch(fetchRequest)
            return results
        } catch let error {
            print(error.localizedDescription)
        }
        return nil
    }
    
    // Fetch one, by its unique object identifier
    func foodItem_GetByObjectId(_ objectId: NSManagedObjectID) -> FoodItem? {
        
        let fetchRequest: NSFetchRequest<FoodItem> = FoodItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "self == %@", objectId)
        
        do {
            let results = try ds_context.fetch(fetchRequest)
            if results.count == 1 {
                return results[0]
            } else {
                return nil
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    // Fetch one, by another attribute that has unique values (e.g. "name")
    func foodItem_GetByName(_ name: String) -> FoodItem? {
        
        let fetchRequest: NSFetchRequest<FoodItem> = FoodItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name ==[c] %@", name)
        
        do {
            let results = try ds_context.fetch(fetchRequest)
            if results.count == 1 {
                return results[0]
            } else {
                return nil
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    // Create new
    func foodItem_CreateItem() -> FoodItem? {
        
        guard let newItem = NSEntityDescription.insertNewObject(forEntityName: "FoodItem", into: ds_context) as? FoodItem else {
            print("Cannot create a new item")
            return nil
        }
        return newItem
    }
    
    // Delete item
    func foodItem_DeleteItem(item: FoodItem) {
        ds_context.delete(item)
        ds_save()
    }
    
    // Delete all
    func foodItem_DeleteAll() {
        if let result = foodItem_GetAll() {
            for obj in result {
                ds_context.delete(obj)
            }
            ds_save()
        }
    }

}
