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

let eventImageReuse = "eventImageReuse"
let eventDateReuse = "eventDateReuse"
let eventTextReuse = "eventTextReuse"

class EventDetailViewController: UIViewController {
    
    var passedEvent : Event!
    
    @IBOutlet weak var detailTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                
                cell.dateLabel.text = passedEvent.eventDate
                cell.locationLabel.text = passedEvent.eventLocation
                cell.timeLabel.text = passedEvent.eventTime
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
