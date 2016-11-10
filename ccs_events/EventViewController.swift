//
//  EventViewController.swift
//  ccs_events
//
//  Created by Amir Nazari on 9/19/16.
//  Copyright © 2016 Amir Nazari. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SDWebImage
import Agrume

let toEventDetail = "toEventDetail"

class EventViewController: UIViewController {

    var ref: FIRDatabaseReference!
    
    @IBOutlet weak var eventTableView: UITableView!
    
    var savedEvents : [Event] = []
    var selectedEvent : Event!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isTranslucent = false
        
        ref = FIRDatabase.database().reference(withPath: "ccs/events")
        
        readAndListenForEvents()
        
        eventTableView.register(UINib.init(nibName: "eventCellTableViewCell", bundle: nil), forCellReuseIdentifier: "cellId")
        eventTableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.items![1].badgeValue = nil
        readAndListenForEvents()
        UserDefaults.standard.set(true, forKey: "badgeUpdate")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        UserDefaults.standard.set(false, forKey: "badgeUpdate")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let eventDetailVC = segue.destination as? EventDetailViewController {
            eventDetailVC.passedEvent = selectedEvent
        }
    }
}

extension EventViewController : UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Required Methods
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellId") as? eventCellTableViewCell else {
            return UITableViewCell()
        }
        
        let elEvent = savedEvents[indexPath.row]
        
        cell.eventTitle.text = elEvent.eventName
        
        cell.eventImage.sd_setImage(with: URL(string: elEvent.eventImage), placeholderImage: #imageLiteral(resourceName: "events-placeholder"))
        cell.eventDescription.text = elEvent.eventDescription
        
        return cell
        
    }

    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedEvents.count
    }
    
    //MARK: Optional Methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedEvent = savedEvents[indexPath.row]
        performSegue(withIdentifier: toEventDetail, sender: self)
    }
}

// MARK: - Firebase
extension EventViewController {
    func readAndListenForEvents() {
        ref.queryOrderedByKey().observe(.value) { (snap : FIRDataSnapshot) in
            
            // Clear old list to make room for new events
            self.savedEvents = []
            
            if snap.hasChildren() {
                // Loop through all event children
                for child in snap.children {
                    // Create new event object using Data snapshot
                    let newEvent = Event(snapshot: child as! FIRDataSnapshot)
                    // Add new event to saved event list
                    self.savedEvents.append(newEvent)
                }
                self.savedEvents = self.savedEvents.reversed()
            }
            let isEventFeedVisible = UserDefaults.standard.bool(forKey: "badgeUpdate")
            
            if isEventFeedVisible {
                UserDefaults.standard.set(self.savedEvents.count, forKey: "eventCount")
            }
            
            // Reload table
            self.eventTableView.reloadData()
        }
    }
}
