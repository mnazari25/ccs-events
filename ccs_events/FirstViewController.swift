//
//  FirstViewController.swift
//  ccs_events
//
//  Created by Amir Nazari on 9/19/16.
//  Copyright © 2016 Amir Nazari. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class FirstViewController: UIViewController {
    
    var eventRef : FIRDatabaseReference!
    var notificationRef : FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isTranslucent = false
        
        eventRef = FIRDatabase.database().reference(withPath: "MyNetwork/event_count")
        notificationRef = FIRDatabase.database().reference().child("MyNetwork/notifications")
        FIRMessaging.messaging().subscribe(toTopic: "/topics/event")
        
        UserDefaults.standard.set(false, forKey: "badgeUpdate")
        UserDefaults.standard.set(false, forKey: "notificationBadgeUpdate")
        
        eventRef.observe(.value) { (snap : FIRDataSnapshot) in
            guard let eventCount = snap.value as? Int else {
                return
            }
            
            let oldEventCount = UserDefaults.standard.integer(forKey: "eventCount")
            
            if eventCount == 0 {
                return
            }
            
            if eventCount > oldEventCount {
                let isEventFeedVisible = UserDefaults.standard.bool(forKey: "badgeUpdate")
                
                if !isEventFeedVisible {
                    self.tabBarController?.tabBar.items![1].badgeValue = "\(eventCount - oldEventCount)"
                }
                
            } else {
                UserDefaults.standard.set(eventCount, forKey: "eventCount")
                self.tabBarController?.tabBar.items![1].badgeValue = nil
            }
        }
        
        notificationRef.observe(.value) { (snap : FIRDataSnapshot) in
            guard let notificationCount = snap.value as? Int else {
                return
            }
            
            let oldNotificationCount = UserDefaults.standard.integer(forKey: "notificationCount")
            
            if notificationCount == 0 {
                UserDefaults.standard.set(notificationCount, forKey: "notificationCount")
                self.tabBarController?.tabBar.items![2].badgeValue = nil
                return
            }
            
            if notificationCount > oldNotificationCount {
                let isEventFeedVisible = UserDefaults.standard.bool(forKey: "notificationBadgeUpdate")
                
                if !isEventFeedVisible {
                    self.tabBarController?.tabBar.items![2].badgeValue = "\(notificationCount - oldNotificationCount)"
                }
                
            } else {
                UserDefaults.standard.set(notificationCount, forKey: "notificationCount")
                self.tabBarController?.tabBar.items![2].badgeValue = nil
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UserDefaults.standard.set(false, forKey: "badgeUpdate")
        UserDefaults.standard.set(false, forKey: "notificationBadgeUpdate")
    }
}

