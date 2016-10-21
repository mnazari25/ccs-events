//
//  eventCellTableViewCell.swift
//  ccs_events
//
//  Created by Amir Nazari on 9/28/16.
//  Copyright © 2016 Amir Nazari. All rights reserved.
//

import UIKit

class eventCellTableViewCell: UITableViewCell {

    // Outlets
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventDescription: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
