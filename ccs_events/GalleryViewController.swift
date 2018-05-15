//
//  GalleryViewController.swift
//  ccs_events
//
//  Created by Amir Nazari on 11/6/16.
//  Copyright © 2016 Amir Nazari. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import Agrume
import MapleBacon

class GalleryViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    @IBOutlet weak var daCollectionView: UICollectionView!
    var galleryImageObjects: [GalleryItem] = []
    
    var ref: FIRDatabaseReference!
    var imageRef: FIRStorageReference!
    
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
        
        // Do any additional setup after loading the view.
        let storage = FIRStorage.storage()
        // Create a root reference
        imageRef = storage.reference()
        
        ref = FIRDatabase.database().reference(withPath: "ccs/gallery")
        ref.child("Images").observe(FIRDataEventType.value, with: { (snapshot) in
            var tempGallery: [GalleryItem] = []
            
            for child in snapshot.children {
                
                let galleryObject = GalleryItem()
                
                guard let snap = child as? FIRDataSnapshot else {
                    return
                }
                
                galleryObject.key = snap.key
                
                if snap.hasChild("title") {
                    if let title = snap.childSnapshot(forPath: "title").value as? String {
                        galleryObject.title = title
                    }
                }
                
                if snap.hasChild("downloadURL") {
                    if let downloadURL = snap.childSnapshot(forPath: "downloadURL").value as? String {
                        galleryObject.downloadURL = downloadURL
                    }
                }
                
                tempGallery.append(galleryObject)
            }
            
            if tempGallery.containsSameElements(as: self.galleryImageObjects) {
                // no changes
                return
            } else {
                self.galleryImageObjects = tempGallery
            }
            
            DispatchQueue.main.async {
                self.daCollectionView.reloadData()
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UserDefaults.standard.set(false, forKey: "badgeUpdate")
        UserDefaults.standard.set(false, forKey: "notificationBadgeUpdate")
    }
    
    private func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return galleryImageObjects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! GalleryCollectionViewCell
        cell.backgroundColor = UIColor.white
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 0.5
        cell.frame.size.width = screenWidth / 3
        cell.frame.size.height = screenWidth / 3
        cell.setImage(image: #imageLiteral(resourceName: "gallery"))
        
        cell.galleryImage.tag = indexPath.row
        cell.galleryImage.isUserInteractionEnabled = true
        cell.galleryImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(GalleryViewController.imageTapped(_:))))
        
        let galleryItem = galleryImageObjects[indexPath.row]
        
        if let url = URL(string: galleryItem.downloadURL) {
            cell.galleryImage.setImage(withUrl: url)
        }
        
        return cell
    }
    
    @objc func imageTapped(_ sender : UITapGestureRecognizer) {
        
        if let imageView = sender.view {
            let tag = imageView.tag
            let agrume = Agrume(imageUrl: URL(string: galleryImageObjects[tag].downloadURL)!)
            agrume.showFrom(self)
        }
    }
}
