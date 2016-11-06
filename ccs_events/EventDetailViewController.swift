//
//  EventDetailViewController.swift
//  ccs_events
//
//  Created by Amir Nazari on 9/30/16.
//  Copyright © 2016 Amir Nazari. All rights reserved.
//

import UIKit
import AVFoundation
import SDWebImage
import EventKit

let eventImageReuse = "eventImageReuse"
let eventDateReuse = "eventDateReuse"
let eventTextReuse = "eventTextReuse"

class EventDetailViewController: UIViewController {
    
    var passedEvent : Event!
    
    @IBOutlet weak var detailTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isTranslucent = false
        
        if passedEvent == nil {
            _ = self.navigationController?.popToRootViewController(animated: true)
        }

        // Do any additional setup after loading the view.
        self.title = passedEvent.eventName
        
        detailTable.estimatedRowHeight = 300.0
        detailTable.rowHeight = UITableViewAutomaticDimension
        
        detailTable.register(UINib.init(nibName: "EventImageTableViewCell", bundle: nil), forCellReuseIdentifier: eventImageReuse)
        detailTable.register(UINib.init(nibName: "EventDateTableViewCell", bundle: nil), forCellReuseIdentifier: eventDateReuse)
        detailTable.register(UINib.init(nibName: "EventTextTableViewCell", bundle: nil), forCellReuseIdentifier: eventTextReuse)
        detailTable.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    @IBAction func addEventToCalendario(_ sender: UIButton) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        guard let date = formatter.date(from: "20161029") else { return }
    
        addEventToCalendar(title: passedEvent.eventName, description: passedEvent.eventDescription, startDate: date, endDate: date, completion: { (success, error) in
            
            if success {
                print("successfully saved events")
                let alert = UIAlertController.alert(withTitle: "Evento salvó al Calendario", message: "El evento se ha guardado en el calendario.", actions: [UIAlertAction.init(title: "De acuerdo", style: .default, handler: nil)], alertType: .alert)
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            if error != nil {
                print("there was an error saving the event")
                let alert = UIAlertController.alert(withTitle: "Error", message: "Ahorro de evento para el calendario de error. Por favor, inténtelo de nuevo.", actions: [UIAlertAction.init(title: "De acuerdo", style: .default, handler: nil)], alertType: .alert)
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    func addEventToCalendar(title: String, description: String?, startDate: Date, endDate: Date, completion: ((_ success: Bool, _ error: NSError?) -> Void)? = nil) {
        let eventStore = EKEventStore()

        eventStore.requestAccess(to: .event, completion: { (granted, error) in
            if (granted) && (error == nil) {
  
                var event : EKEvent?
                if let savedEventID = self.passedEvent.savedEventID {
                    event = eventStore.event(withIdentifier: savedEventID)
                }
                
                if event == nil {
                    event = EKEvent(eventStore: eventStore)
                } else {
                    print("already saved event")
                    let alert = UIAlertController.alert(withTitle: "Ya Guardado", message: "Este evento ya se guarda en el calendario.", actions: [UIAlertAction.init(title: "De acuerdo", style: .default, handler: nil)], alertType: .alert)
                    self.present(alert, animated: true, completion: nil)
                    completion?(false, nil)
                    return
                }
                
                event!.title = title
                event!.startDate = startDate
                event!.endDate = endDate
                event!.notes = description
                event!.calendar = eventStore.defaultCalendarForNewEvents
                
                do {
                    try eventStore.save(event!, span: .thisEvent)
                    self.passedEvent.savedEventID = event?.eventIdentifier
                } catch let e as NSError {
                    completion?(false, e)
                    return
                }
                completion?(true, nil)
            } else {
                completion?(false, error as NSError?)
            }
        })
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension EventDetailViewController : UITableViewDataSource, UITableViewDelegate {
    //MARK: Required Methods
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: eventImageReuse) as? EventImageTableViewCell {
                cell.eventImage.sd_setImage(with: URL(string: passedEvent.eventImage), placeholderImage: #imageLiteral(resourceName: "events-placeholder"))
                return cell
            }
        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: eventDateReuse) as? EventDateTableViewCell {
                
                let timeInterval : TimeInterval = TimeInterval(passedEvent.eventDate)
                let date = Date(timeIntervalSince1970: timeInterval)
                let dayTimePeriodFormatter = DateFormatter()
                dayTimePeriodFormatter.dateFormat = "hh:mm a"
                let timeString = dayTimePeriodFormatter.string(from: date)
                dayTimePeriodFormatter.dateFormat = "dd-MM-YYYY"
                let dateString = dayTimePeriodFormatter.string(from: date)
                
                var daTimeZone = ""
                if let timeZone = NSTimeZone.local.abbreviation() {
                    daTimeZone = timeZone
                }
                
                cell.dateLabel.text = dateString
                cell.locationLabel.text = passedEvent.eventLocation
                cell.timeLabel.text = "\(timeString) \(daTimeZone)"
                return cell
            }
        case 2:
            if let cell = tableView.dequeueReusableCell(withIdentifier: eventTextReuse) as? EventTextTableViewCell {
                cell.eventText.text = passedEvent.eventDescription
                return cell
            }
        default:
            break
        }
        
        return UITableViewCell()
        
    }
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
}
