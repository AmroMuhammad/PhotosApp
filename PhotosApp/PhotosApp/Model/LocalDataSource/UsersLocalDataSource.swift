//
//  UsersLocalDataSource.swift
//  PhotosApp
//
//  Created by Amr Muhammad on 12/10/21.
//  Copyright © 2021 Amr Muhammad. All rights reserved.
//

import UIKit
import CoreData

class UsersLocalDataSource{
    static let sharedInstance = UsersLocalDataSource()
    
    private let appDelegate:AppDelegate
    private let managedContext:NSManagedObjectContext
    private let entity:NSEntityDescription?
    
    private init(){
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
        entity = NSEntityDescription.entity(forEntityName: Constants.usersDatabaseName,in: managedContext)
    }
    
    func save(user: User,completion: @escaping (Result<Bool,NSError>) -> Void){
        guard let entity = entity else{
            print("cant find entity")
            completion(.failure(NSError(domain: Constants.databaseDomain, code: 0, userInfo: [NSLocalizedDescriptionKey: Constants.genericError])))
            return
        }
        
        let users = NSManagedObject(entity: entity, insertInto: managedContext)
        users.setValue(user.phoneNumber, forKeyPath: Constants.userPhone)
        users.setValue(user.password, forKey: Constants.userPassword)
        
        do {
            try managedContext.save()
            print("ULDS* saved successfully")
            completion(.success(true))
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            completion(.failure(error))
        }
    }
    
    func fetchUser(byPhoneNumber phone:String,completion: @escaping (Result<User,NSError>) -> Void){
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.usersDatabaseName)
        fetchRequest.predicate = NSPredicate(format: "phoneNumber LIKE %@", phone)
        
        do {
            guard let storedUser = try managedContext.fetch(fetchRequest).first else{
                print("user not found")
                completion(.failure(NSError(domain: Constants.databaseDomain, code: 0, userInfo: [NSLocalizedDescriptionKey: Constants.noUserError])))
                return
            }
            let userPhone = storedUser.value(forKey: Constants.userPhone) as! String
            let userPass = storedUser.value(forKey: Constants.userPassword) as! String
            print("ULDS* fetched successfully")
            completion(.success(User(phoneNumber: userPhone, password: userPass)))
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            completion(.failure(NSError(domain: Constants.databaseDomain, code: 0, userInfo: [NSLocalizedDescriptionKey: Constants.noUserError])))
        }
    }
}


