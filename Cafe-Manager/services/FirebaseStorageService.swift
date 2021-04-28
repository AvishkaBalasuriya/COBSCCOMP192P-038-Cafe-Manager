//
//  FirebaseStorageService.swift
//  Cafe-Manager
//
//  Created by Avishka Balasuriya on 2021-04-28.
//

import UIKit
import FirebaseStorage

class FirebaseStorageService: NSObject {
    
    let storage = Storage.storage()
    
    func upload(data:Data,itemId:String,completion: @escaping (Any)->()){
        print("Started to upload")
        let storageRef = storage.reference()
        let itemImageRef = storageRef.child(itemId+".jpg")

        let uploadTask = itemImageRef.putData(data, metadata: nil) { (metadata, error) in
            print(error)
            guard let metadata = metadata else {
                completion("")
                return
            }
            let size = metadata.size
            itemImageRef.downloadURL { (url, error) in
            guard let downloadURL = url else {
                completion("")
                return
            }
            completion(downloadURL)
          }
        }
    }

}
