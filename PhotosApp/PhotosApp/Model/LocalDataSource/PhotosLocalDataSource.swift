//
//  PhotosLocalDataSource.swift
//  PhotosApp
//
//  Created by Amr Muhammad on 12/11/21.
//  Copyright © 2021 Amr Muhammad. All rights reserved.
//

import UIKit
import CoreData

class PhotosLocalDataSource{
    static let sharedInstance = PhotosLocalDataSource()
    
    private let appDelegate:AppDelegate
    private let managedContext:NSManagedObjectContext
    private let entity:NSEntityDescription?
    
    private init(){
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
        entity = NSEntityDescription.entity(forEntityName: Constants.photosDatabaseName,in: managedContext)
    }
    
    func save(photosArray: PhotoModel,completion: @escaping (Result<Bool,NSError>) -> Void){
        print("in photoSave")
        guard let entity = entity else{
            print("cant find entity")
            completion(.failure(NSError(domain: Constants.databaseDomain, code: 0, userInfo: [NSLocalizedDescriptionKey: Constants.genericError])))
            return
        }
        
        for photo in photosArray{
            let photos = NSManagedObject(entity: entity, insertInto: managedContext)
            photos.setValue(photo.id, forKeyPath: Constants.id)
            photos.setValue(photo.author, forKey: Constants.author)
            photos.setValue(photo.width, forKeyPath: Constants.width)
            photos.setValue(photo.height, forKey: Constants.height)
            photos.setValue(photo.url, forKeyPath: Constants.url)
            photos.setValue(photo.downloadURL, forKey: Constants.downloadURL)
            
        }
        do {
            try managedContext.save()
            print("PLDS* saved successfully")
            completion(.success(true))
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            completion(.failure(error))
            return
        }
    }
    
    func fetchAllPhotos(completion: @escaping (PhotoModel?) -> Void){
        var photos = PhotoModel()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.photosDatabaseName)
        
        do {
            let storedPhotos = try managedContext.fetch(fetchRequest)
            for storedPhoto in storedPhotos{
                let photoID = storedPhoto.value(forKey: Constants.id) as! String
                let photoAuthor = storedPhoto.value(forKey: Constants.author) as! String
                let photoWidth = storedPhoto.value(forKey: Constants.width) as! Int
                let photoHeight = storedPhoto.value(forKey: Constants.height) as! Int
                let photoURL = storedPhoto.value(forKey: Constants.url) as! String
                let photoDownloadURL = storedPhoto.value(forKey: Constants.downloadURL) as! String
                photos.append(PhotoModelElement(id: photoID, author: photoAuthor, width: photoWidth, height: photoHeight, url: photoURL, downloadURL: photoDownloadURL))
            }
            
            print("ULDS* fetched successfully")
            if(photos.isEmpty){
                completion(nil)
            }else{
                completion(photos)
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            completion(nil)
        }
    }
    
    func deleteAllData() {
        print("in delete")
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.photosDatabaseName)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try managedContext.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                managedContext.delete(objectData)
            }
        } catch let error {
            print("Detele all data in \(Constants.photosDatabaseName) error :", error)
        }
    }
}


