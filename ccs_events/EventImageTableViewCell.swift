//
//  EventImageTableViewCell.swift
//  ccs_events
//
//  Created by Amir Nazari on 9/30/16.
//  Copyright © 2016 Amir Nazari. All rights reserved.
//

import UIKit

class EventImageTableViewCell: UITableViewCell {

    @IBOutlet weak var eventImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
