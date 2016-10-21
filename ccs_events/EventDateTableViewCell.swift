//
//  EventDateTableViewCell.swift
//  ccs_events
//
//  Created by Amir Nazari on 9/30/16.
//  Copyright © 2016 Amir Nazari. All rights reserved.
//

import UIKit

class EventDateTableViewCell: UITableViewCell {

    // Outlets
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
