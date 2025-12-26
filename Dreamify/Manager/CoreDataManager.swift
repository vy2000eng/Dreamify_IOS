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
    
    func getAllDreamsForUser(userId:UUID) throws -> [Dream] {
        let fetchRequest:NSFetchRequest<Dream> = Dream.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userRelationShip.id == %@", userId.uuidString)

        
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
        // get user email from token manager
        guard let userEmail = TokenManager.shared.getUserEmail() else {
            throw NSError(domain: "User Retrieval Error", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not retrieve user from internal storage"])
        }
        //create fetch request for user
        let fetchRequest:NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userEmail == %@", userEmail as CVarArg)
        
        do{
            // create new dream
            let newDream          = Dream(context: context)
            newDream.title        = title
            newDream.url          = url
            newDream.id           = UUID()
            newDream.created_date = Date()
            newDream.transcribedText = transribedText
            newDream.tag = nil
            //retrieve user
            guard let user  = try context.fetch(fetchRequest).first else{
                throw NSError(domain: "CoreDataManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "User not found"])
            }
            //construct relationships
            user.addToDreamRelationShip(newDream)
            newDream.userRelationShip = user
            //save to db
            try context.save()


            
        
        }catch let err as NSError{
            throw err
            
        }
    }
    
    func addDreamTestDream(title:String, url:String, transribedText:String?, date:Date) throws{
        
        
        guard let userEmail = TokenManager.shared.getUserEmail() else {
            throw NSError(domain: "User Retrieval Error", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not retrieve user from internal storage"])
        }
        //create fetch request for user
        let fetchRequest:NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userEmail == %@", userEmail as CVarArg)
        
        let newDream          = Dream(context: context)
        newDream.title        = title
        newDream.url          = url
        newDream.id           = UUID()
        newDream.created_date = date
        newDream.transcribedText = transribedText
        newDream.tag = "No Tag"

        
        guard let user  = try context.fetch(fetchRequest).first else{
            throw NSError(domain: "CoreDataManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "User not found"])
        }
        //construct relationships
        user.addToDreamRelationShip(newDream)
        newDream.userRelationShip = user
        
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
    //TODO: this function should throw, all of these funcitons should throw
    func updateDream(dreamId: UUID, dreamTitle: String? = nil, dreamTranscription: String? = nil, tag:String? = nil) {
        // Check if at least one parameter is provided
        guard dreamTitle != nil || dreamTranscription != nil || tag != nil else {
            print("No updates provided - both dreamTitle and dreamTranscription are nil")
            return
        }
        
        let fetchRequest: NSFetchRequest<Dream> = Dream.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", dreamId.uuidString)
        
        do {
            guard let dream = try context.fetch(fetchRequest).first else {
                print("Dream not found with id: \(dreamId)")
                return
            }
            
            // Update title if provided
            if let newTitle = dreamTitle {
                dream.title = newTitle
            }
            
            // Update transcription if provided
            if let newTranscription = dreamTranscription {
                dream.transcribedText = newTranscription // or whatever your property name is
            }
            
                dream.tag = tag
            
            try context.save()
            print("Dream updated successfully")
            
        } catch let error as NSError {
            print("Error updating dream: \(error.userInfo), \(error.localizedDescription)")
        }
    }
    
    
    func addDreamWithOutTextTranscription(title:String, url:String) throws{
        let newDream          = Dream(context: context)
        newDream.title        = title
        newDream.url          = url
        newDream.id           = UUID()
        newDream.created_date = Date()
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
    // user Entity
    func getUserByEmail(email:String) throws -> UserEntityModel{
        let fetchRequest:NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userEmail == %@", email as CVarArg)

        do{
            //try CoreDataManager.shared.getUSerByEmail(email: email)
            guard let user  = try context.fetch(fetchRequest).first else{
                throw NSError(domain: "CoreDataManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "User not found"])
                

                
            }
            
            return UserEntityModel(userEntity: user)
            
        }catch let err as NSError{
            throw NSError(domain: "CoreDataManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to retrieve user from internal database"])

            
        }
        
        
        
    }
    
    func deleteAllDataForUser(email:String) throws -> Void {
        do{
            
            // get user
            guard let userEmail = TokenManager.shared.getUserEmail() else {
                throw NSError(domain: "User Retrieval Error", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not retrieve user from internal storage"])
            }
            // generate request for fetching user
            let userFetchRequest:NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
            userFetchRequest.predicate = NSPredicate(format: "userEmail == %@", userEmail as CVarArg)
            
            //retrieve user for whom to delete all internal data
            guard let user  = try context.fetch(userFetchRequest).first else{
                throw NSError(domain: "CoreDataManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "User not found"])
            }
            
            //retrieve all dreams
            let fetchRequest:NSFetchRequest<Dream> = Dream.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "userRelationShip.id == %@", user.id.uuidString as CVarArg)
            var dreams = try context.fetch(fetchRequest)
            //delete every dream
            for dream in dreams{
                // delete the url path
                guard let dreamUrl = dream.url else{
                    throw NSError(domain:"Dream Url Error", code: 1, userInfo: [NSLocalizedDescriptionKey:"Unable to retrieve dream path to delete file"])
                }
                let url = getDocumentsDirectory().appendingPathComponent(dreamUrl)
                if FileManager.default.fileExists(atPath: url.path) {
                    try FileManager.default.removeItem(at: url) // Use 'at:' not 'atPath:'
                    print("Deleted file: \(url.lastPathComponent)")
                } else {
                    print("File doesn't exist: \(url.path)")
                }
          
                context.delete(dream)
            }
            //delete the subsequent user associated with the dream
            context.delete(user)
            try context.save()
            
        }catch let err as NSError{
            throw NSError(domain:err.domain, code: err.code, userInfo: [NSLocalizedDescriptionKey:err.localizedDescription])

        }
        
    }
    
    
    func addUser(email: String) throws -> UserEntityModel {
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userEmail == %@", email)
        
        // Check if user with this email already exists
        let existingUsers = try context.fetch(fetchRequest)
        
        if let existingUser = existingUsers.first {
            // User already exists, return it
            return UserEntityModel(userEntity: existingUser)
        } else {
            // User doesn't exist, create new one
            let user = UserEntity(context: context)
            user.id = UUID()
            user.userEmail = email
            
            do {
                try context.save()
                return UserEntityModel(userEntity: user)
            } catch let err as NSError {
                print("Error saving user: \(err), \(err.userInfo)")
                throw err
            }
        }
    }

    
    
    
}
