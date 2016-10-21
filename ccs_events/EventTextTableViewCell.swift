//
//  EventTextTableViewCell.swift
//  ccs_events
//
//  Created by Amir Nazari on 10/5/16.
//  Copyright © 2016 Amir Nazari. All rights reserved.
//

import UIKit

class EventTextTableViewCell: UITableViewCell {

    // Outlets
    @IBOutlet weak var eventText: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
