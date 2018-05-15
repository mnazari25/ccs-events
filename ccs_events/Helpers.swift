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

func getImageFromStorageRef(title: String, imageView: UIImageView, event: Event?) {
    
    if title == "" {
        return
    }
    
    let storage = FIRStorage.storage()
    let imageRef = storage.reference(withPath: "images/\(title)")
    
    imageRef.downloadURL { url, error in
        if let error = error {
            // Handle any errors
            print("error downloading image")
            print(error.localizedDescription)
            imageView.image = #imageLiteral(resourceName: "events-placeholder")
            return
        } else {
            if let download = url {
                
                if let thisEvent = event {
                    thisEvent.downloadImageURL = download.absoluteString
                }
                
                imageView.setImage(withUrl: download)
            }
        }
    }
}

extension Array where Element: Comparable {
    func containsSameElements(as other: [Element]) -> Bool {
        return self.count == other.count && self.sorted() == other.sorted()
    }
}
