//
//  ViewController.swift
//  iosTest-OgariPataPacheco
//
//  Created by Ogari Pata Pacheco on 18/01/2020.
//  Copyright © 2020 Ogari Pata Pacheco. All rights reserved.
//

import UIKit
//import AKVideoImageView

class ViewController: UIViewController, UICollectionViewDataSource {
//    var imgURLsArray : [String] = []
    var services: APIServices = APIServices()
    
    @IBOutlet weak var collectionView: UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        
        print ("Main View loaded!")
        let imgGallery = services.imgurFetchPhotoRequest(collectionView: self.collectionView)
        print(imgGallery)
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return services.imgURLsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customImageCell", for: indexPath) as! CollectionViewCustomImageCell
        
        cell.imageView.contentMode = .scaleAspectFill
        cell.imageView.downloaded(from: services.imgURLsArray[indexPath.row])
        
        return cell
    }
    
}
