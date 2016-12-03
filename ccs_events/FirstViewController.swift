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
    
    var ref : FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isTranslucent = false
        
        ref = FIRDatabase.database().reference(withPath: "MyNetwork/event_count")
        FIRMessaging.messaging().subscribe(toTopic: "/topics/event")
        
        UserDefaults.standard.set(false, forKey: "badgeUpdate")
        
        ref.observe(.value) { (snap : FIRDataSnapshot) in
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
    }
}

