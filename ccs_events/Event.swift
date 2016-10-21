//
//  Event.swift
//  ccs_events
//
//  Created by Amir Nazari on 10/5/16.
//  Copyright © 2016 Amir Nazari. All rights reserved.
//

import Foundation
import UIKit

class Event : NSObject {
    var eventName : String
    var eventDate : String
    var eventLocation : String
    var eventTime : String
    var eventDescription : String
    var eventImage : UIImage
    
    init(eventName : String, eventDate : String,
         eventLocation : String, eventTime : String,
         eventDescription : String, eventImage : UIImage) {

        self.eventName = eventName
        self.eventDate = eventDate
        self.eventLocation = eventLocation
        self.eventDescription = eventDescription
        self.eventTime = eventTime
        self.eventImage = eventImage
        
    }
    
}
