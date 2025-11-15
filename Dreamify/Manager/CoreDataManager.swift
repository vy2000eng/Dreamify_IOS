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
    func getAllDreamsCreatedByDate() throws -> [Dream] {
        
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
    
    func addDreamTestDream(title:String, url:String, transribedText:String?, date:Date) throws{
        let newDream          = Dream(context: context)
        newDream.title        = title
        newDream.url          = url
        newDream.id           = UUID()
        newDream.created_date = date
        newDream.transcribedText = transribedText
        do{
            try context.save()
        }catch let err as NSError{
            print("Error saving a dream from funciton call addDream(title:String, url:String) \(err), \(err.userInfo)")
            throw err
        }
    }
    
    func updateAnalyzedTextForDream(analyzedText:String, dreamId:UUID){
        let fetchRequest: NSFetchRequest<Dream> = Dream.fetchRequest()
        fetchRequest.predicate = NSPredicate(format:"id == %@", dreamId.uuidString)
        do{
            let dream = try context.fetch(fetchRequest).first
            dream?.analyzedText = analyzedText
            try context.save()
        }catch let error as NSError{
            print("Error updating dream: \(error.userInfo), \(error.localizedDescription)")
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
    func getDreamByID(id:UUID) throws -> DreamViewModel{
        let fetchRequest : NSFetchRequest<Dream> = Dream.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id==%@", id as CVarArg)
        
        
        do{
            guard let dream = try context.fetch(fetchRequest).first else {
                throw NSError(domain: "CoreDataManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Dream not found"])
            }
            var dreamViewModel = DreamViewModel(dream: dream)
            return dreamViewModel
            
        }
        catch{
            throw NSError(domain: "CoreDataManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to delete dream"])

            
        }
     
        

        
        
    }
    
    func deleteDreamById(dreamId:UUID)throws -> Void {
        let fetchRequest: NSFetchRequest<Dream> = Dream.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id==%@", dreamId as CVarArg)
        do{
            guard let dream = try context.fetch(fetchRequest).first else {
                throw NSError(domain: "CoreDataManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Dream not found"])
            }
            context.delete(dream)
            try context.save()
        }catch let error as NSError{
            throw NSError(domain: "CoreDataManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to delete dream"])
        }
        
        

        
    }

    
    
}
