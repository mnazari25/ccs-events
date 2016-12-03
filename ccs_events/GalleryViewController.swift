//
//  GalleryViewController.swift
//  ccs_events
//
//  Created by Amir Nazari on 11/6/16.
//  Copyright © 2016 Amir Nazari. All rights reserved.
//

import UIKit
import Agrume

class GalleryViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    @IBOutlet weak var daCollectionView: UICollectionView!
    let images = [#imageLiteral(resourceName: "profile-pictures-14"), #imageLiteral(resourceName: "IMG_1122"), #imageLiteral(resourceName: "events-placeholder"), #imageLiteral(resourceName: "school"), #imageLiteral(resourceName: "play")]
    
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        // Do any additional setup after loading the view, typically from a nib
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: screenWidth / 3, height: screenWidth / 3)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        daCollectionView.setCollectionViewLayout(layout, animated: true)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        UserDefaults.standard.set(false, forKey: "badgeUpdate")
    }
    
    private func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! GalleryCollectionViewCell
        cell.backgroundColor = UIColor.white
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 0.5
        cell.frame.size.width = screenWidth / 3
        cell.frame.size.height = screenWidth / 3
        cell.setImage(image: images[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let agrume = Agrume(images: images, startIndex: indexPath.row, backgroundBlurStyle: .light)
        agrume.didScroll = { [unowned self] index in
            self.daCollectionView.scrollToItem(at: IndexPath(row: index, section: 0),
                                              at: [],
                                              animated: false)
        }
        agrume.showFrom(self)
    }
}
