//
//  GalleryCollectionViewCell.swift
//  ccs_events
//
//  Created by Amir Nazari on 11/6/16.
//  Copyright © 2016 Amir Nazari. All rights reserved.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var galleryImage: UIImageView!
    
    func setImage(image : UIImage) {
        galleryImage.image = image
    }
}
