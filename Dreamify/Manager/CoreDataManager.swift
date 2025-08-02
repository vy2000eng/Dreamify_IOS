//
//  CoreDataManager.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 7/13/25.
//

import CoreData
class CoreDataManager{
    static var shared = CoreDataManager()
    let persistentContainer: NSPersistentContainer
    
    init(inMemory: Bool = false) {



        //ValueTransformer.setValueTransformer(UIColorTransformer(), forName: NSValueTransformerName("UIColorTransformer"))
        
        persistentContainer = NSPersistentContainer(name: "Dreamify")
        if inMemory {
            persistentContainer.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        persistentContainer.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved Error \(error), \(error.userInfo)")
            }
        }
        
        
 
    }
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        persistentContainer.performBackgroundTask(block)
    }
    
    
    func saveContext(){
        if context.hasChanges{
            do{
                try context.save()
            }catch let error as NSError{
                print("Error saving the staged changes \(error), \(error.userInfo)")
            }
        }
    }
    
    // these error are propogated through the scope of the calling method and as such are handled there too
    func getAllDreams() throws -> [Dream] {
        let fetchRequest:NSFetchRequest<Dream> = Dream.fetchRequest()
        do {
            let dreams = try context.fetch(fetchRequest)
            return dreams
            
        }catch let err as NSError{
            print("Error retrieving dreams from function call getAllDreams() \(err), \(err.userInfo)")

            throw err
        }
    }
    
    func addDream(title:String, url:String, transribedText:String?) throws{
        let newDream          = Dream(context: context)
        newDream.title        = title
        newDream.url          = url
        newDream.id           = UUID()
        newDream.created_date = Date()
        newDream.transcribedText = transribedText
        do{
            try context.save()
        }catch let err as NSError{
            print("Error saving a dream from funciton call addDream(title:String, url:String) \(err), \(err.userInfo)")
            throw err
        }
    }
    
    func addDreamWithOutTextTranscription(title:String, url:String) throws{
        let newDream          = Dream(context: context)
        newDream.title        = title
        newDream.url          = url
        newDream.id           = UUID()
        newDream.created_date = Date()
        //newDream.transcribedText = transribedText
        do{
            try context.save()
        }catch let err as NSError{
            print("Error saving a dream from funciton call addDream(title:String, url:String) \(err), \(err.userInfo)")
            throw err
        }
    }
    
    //MARK: TODO
    func deleteAllDreams(){
        
    }
    func getDreamByID(){
        
    }
    
    func deleteDreamVyId() {

        
    }
    
    
}
