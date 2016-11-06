//
//  Constants.swift
//  ccsevents-admin
//
//  Created by Amir Nazari on 10/21/16.
//  Copyright © 2016 Amir Nazari. All rights reserved.
//

import Foundation
import UIKit

extension NotificationCenter {
    static var SECONDARY_ACTION_NOTIFICATION : NSNotification.Name {
        return NSNotification.Name(rawValue: "SECONDARY_ACTION_NOTIFICATION")
    }
}

class Constants {
    static let adminNotesKey = "adminNotes"
    static let eventNameKey = "eventName"
    static let eventDateKey = "eventDate"
    static let eventLocationKey = "eventLocation"
    static let eventDescriptionKey = "eventDescription"
    static let eventTimeKey = "eventTime"
    static let eventImageKey = "eventImage"
    
    static let facebookSocialLink = "fb://profile/111211452282555"
    static let facebookSocialWebLink = "https://www.facebook.com/CCSampedrano/"
    static let twitterSocialLink = "twitter://user?screen_name=CCSsps"
    static let twitterSocialWebLink = "https://twitter.com/CCSsps"
}

extension UIAlertController {
    
    /// Helper method for creating an alert controller and adding each of the actions to it.
    ///
    /// - parameter title:     Title of the alert controller
    /// - parameter message:   Message body of the alert controller
    /// - parameter actions:   List of UIAlertActions that define what buttons the user sees on the alert controller and what functionality should run when tapped
    /// - parameter alertType: The type of alert controller that will be returned
    ///
    /// - returns: An alert controller composed of all the incoming parameters' values
    static func alert(withTitle title : String,
                      message : String,
                      actions : [UIAlertAction],
                      alertType : UIAlertControllerStyle) -> UIAlertController {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: alertType)
        
        for action in actions {
            alert.addAction(action)
        }
        
        return alert
    }
}
