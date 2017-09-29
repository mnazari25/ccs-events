//
//  NotificationViewController.swift
//  ccs_events
//
//  Created by Amir Nazari on 12/13/16.
//  Copyright © 2016 Amir Nazari. All rights reserved.
//

import UIKit
import Firebase

class NotificationViewController: UIViewController {

    var ref : FIRDatabaseReference!
    @IBOutlet weak var notificationTableView: UITableView!
    
    var savedNotification : [CustomNotification] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        ref = FIRDatabase.database().reference().child("ccs/notifications")
        
        readAndListenForEvents(shouldSaveCount: true)
        
        notificationTableView.rowHeight = UITableViewAutomaticDimension
        notificationTableView.estimatedRowHeight = 75
        notificationTableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.items![2].badgeValue = nil
        readAndListenForEvents(shouldSaveCount : true)
        UserDefaults.standard.set(false, forKey: "badgeUpdate")
        UserDefaults.standard.set(true, forKey: "notificationBadgeUpdate")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        ref.removeAllObservers()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedNotification.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuse") as? NotificationCell {
            
            let notification = savedNotification[indexPath.row]
            
            cell.messageTitleLabel.text = notification.messageTitle
            cell.messageLabel.text = notification.message
            cell.messageDateLabel.text = notification.date
            
            return cell
        }
        
        return UITableViewCell()
    }
}

// MARK: - Firebase
extension NotificationViewController {
    func readAndListenForEvents(shouldSaveCount : Bool) {
        ref.queryOrderedByKey().observe(.value) { (snap : FIRDataSnapshot) in
            
            // Clear old list to make room for new notifications
            self.savedNotification = []
            
            if snap.hasChildren() {
                // Loop through all notification children
                for child in snap.children {
                    // Create new notification object using Data snapshot
                    let newEvent = CustomNotification(snapshot: child as! FIRDataSnapshot)
                    // Add new notification to saved notification list
                    self.savedNotification.append(newEvent)
                }
                self.savedNotification = self.savedNotification.reversed()
            }
            
            if shouldSaveCount {
                UserDefaults.standard.set(self.savedNotification.count, forKey: "notificationCount")
            }
            
            if self.savedNotification.isEmpty {
                self.notificationTableView.isHidden = true
            } else {
                self.notificationTableView.isHidden = false
            }
            
            // Reload table
            self.notificationTableView.reloadData()
        }
    }
}
