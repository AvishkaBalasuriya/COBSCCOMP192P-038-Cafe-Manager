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

        itemImageRef.putData(data, metadata: nil) { (metadata, error) in
            if (error == nil){
                print("Uploaded")
                itemImageRef.downloadURL(){
                    url,error in
                    if (error == nil){
                        completion(url?.absoluteString)
                    }else{
                        print("Unable to get download url")
                        completion("")
                    }
                }
            }else{
                completion("")
            }
        }
    }

}
