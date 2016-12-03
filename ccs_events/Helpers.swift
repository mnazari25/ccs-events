//
//  Helpers.swift
//  ccs_events
//
//  Created by Amir Nazari on 11/15/16.
//  Copyright © 2016 Amir Nazari. All rights reserved.
//

import Foundation
import UIKit
import Firebase

func getImageFromStorageRef(title: String, imageView: UIImageView) {
    
    imageView.image = #imageLiteral(resourceName: "events-placeholder")
    
    if title == "" {
        return
    }
    
    let storage = FIRStorage.storage()
    let imageRef = storage.reference(withPath: "images/\(title)")
    
    imageRef.data(withMaxSize: 1 * 2000 * 2000) { (data, error) -> Void in
        if (error != nil) {
            // Uh-oh, an error occurred!
            print("error downloading image")
            print(error?.localizedDescription ?? "")
            imageView.image = #imageLiteral(resourceName: "events-placeholder")
        } else {
            let theImage: UIImage! = UIImage(data: data!)
            imageView.image = theImage
        }
    }
}
