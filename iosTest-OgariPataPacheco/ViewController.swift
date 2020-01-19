//
//  ViewController.swift
//  iosTest-OgariPataPacheco
//
//  Created by Ogari Pata Pacheco on 18/01/2020.
//  Copyright © 2020 Ogari Pata Pacheco. All rights reserved.
//

import UIKit
import AKVideoImageView

class ViewController: UIViewController, UICollectionViewDataSource {
    var imgURLsArray : [String] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        
        // TESTING
        print ("ENTREI!!!")
        let imgGallery = self.fetchPhotoRequest(clientID: "Client-ID 1ceddedc03a5d71")
        print(imgGallery)
    }

    func getImageURLs(gallery: Array<Any>){
        for i in 0...gallery.count {
            print(i)
            guard let imgs = (gallery[i] as AnyObject)["images"] as? Array<Any>
                else {
                    // CHECK FOR MISTAKES HERE!
                    print("Error: gallery images error") // FIX
                    return
            }

//            print(gallery.count)

            guard let imgURL = (imgs[0] as AnyObject)["link"] as? String
                else {
                    print("Error: imgURL link error") // FIX
                    return
            }
            
            print(imgURL) // OK
            
            self.imgURLsArray.append(imgURL)
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
//        DispatchQueue.main.async {
//            self.collectionView.reloadData()
//        }

    }
    
    func fetchPhotoRequest(clientID: String)  {
        
        let string = "https://api.imgur.com/3/gallery/search/?q=cats"
        let url = NSURL(string: string)
        let request = NSMutableURLRequest(url: url! as URL)
        request.setValue(clientID, forHTTPHeaderField: "Authorization") //**
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared

        let mData = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if let res = response as? HTTPURLResponse {
//                print("res: \(String(describing: res))")
//                print("Response: \(String(describing: response))")

                guard let data = data, !data.isEmpty else {
                    print("Error: data is nil or empty")
                    return
                }

                guard let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) else {
                    print("Error: data contains no JSON")
                    return
                }

//                print("JSON!!!")
//                print(json)

                guard let jsonObj = json as? [String: Any] else {
                    print("Error: JSON is not a dictionary")
                    return
                }

                print("JSON DICTIONARY!!!")
//                print(jsonObj)
//                print((jsonObj as AnyObject).data)
//                print((jsonObj as AnyObject).data[0])

                guard let galleryData = jsonObj["data"] as? Array<Any> else {
                    print("Error: Object has no 'telefon' key") // FIX
                    return
                }

                self.getImageURLs(gallery: galleryData)


            }else{
                print("Error: \(String(describing: error))")
            }
        }
        mData.resume()
//        print(imgURLsArray) // <= RESOLVER PROBLEMA DE ASSINCRONISMO
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgURLsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customImageCell", for: indexPath) as! CollectionViewCustomImageCell
        
        cell.imageView.contentMode = .scaleAspectFill
        cell.imageView.downloaded(from: imgURLsArray[indexPath.row])
        
        return cell
    }
    
}
