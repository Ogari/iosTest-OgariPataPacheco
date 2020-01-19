//
//  ViewController.swift
//  iosTest-OgariPataPacheco
//
//  Created by Ogari Pata Pacheco on 18/01/2020.
//  Copyright © 2020 Ogari Pata Pacheco. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
//    var imgURLsArray : [String] = []
    
    // TESTING
//    let testArray: [String] = ["FotoA.jpeg",
//                               "FotoB.jpeg",
//                               "FotoC.jpeg",
//                               "FotoD.jpeg",
//                               "FotoE.jpeg",
//                               "FotoF.jpeg",
//                               "FotoG.jpg"]
    
    var services: APIServices = APIServices()
    
    @IBOutlet weak var collectionView: UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        
        print ("Main View loaded!")
        let imgGallery = services.imgurFetchPhotoRequest(collectionView: self.collectionView)
        print(imgGallery)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else
        {
            return
        }
        
        print("BOUNDS")
        print(collectionView.bounds)
        collectionView.bounds = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height)
        print(collectionView.bounds)
        let bounds = collectionView.bounds
        
        layout.itemSize = CGSize(width: self.view.bounds.width/2.2, height: self.view.bounds.height/2.2)
        
        layout.minimumInteritemSpacing = 0
//        layout.minimumLineSpacing = 0
        layout.prepare()  // <-- call prepare before invalidateLayout
        layout.invalidateLayout()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return services.imgURLsArray.count
//        return testArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customImageCell", for: indexPath) as! CollectionViewCustomImageCell
        
//        cell.imageView.contentMode = .scaleAspectFill
        
//        cell.imageView.image = UIImage(named: testArray[indexPath.row]) // => FOR TESTING
//        cell.imageView.adjustsImageSizeForAccessibilityContentSizeCategory = true
        cell.imageView.downloaded(from: services.imgURLsArray[indexPath.row])
        
//        cell.imageView.clipsToBounds = true
        cell.imageView.layer.cornerRadius = 25.0 //cell.imageView.frame.height/2
//        cell.imageView.siz
        cell.backgroundColor = .black
        
        return cell
    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = collectionView.bounds
        
        //        return CGSize(width: bounds.width/2, height: 150)
        return CGSize(width: 600, height: 900)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    
    
    
}
