//
//  APIServices.swift
//  iosTest-OgariPataPacheco
//
//  Created by Ogari Pata Pacheco on 19/01/2020.
//  Copyright © 2020 Ogari Pata Pacheco. All rights reserved.
//

import Foundation
import UIKit

class APIServices {
    var imgURLsArray : [String] = []
    let global: GlobalAssets = GlobalAssets()
    
    func imgurGetImageURLs(gallery: Array<Any>, collectionView: UICollectionView){
        for i in 0...gallery.count-1 {
            print(i)
            guard let imgs = (gallery[i] as AnyObject)["images"] as? Array<Any>
                else {
                    // CHECK FOR MISTAKES HERE!
                    print("Error: gallery images error") // FIX
                    return
            }

            guard let imgURL = (imgs[0] as AnyObject)["link"] as? String
                else {
                    print("Error: imgURL link error") // FIX
                    return
            }
            
            print(imgURL) // OK
            imgURLsArray.append(imgURL)
            DispatchQueue.main.async {
               collectionView.reloadData()
            }
        }
        //        DispatchQueue.main.async {
        //            self.collectionView.reloadData()
        //        }
        
    }
    
    func imgurFetchPhotoRequest(collectionView: UICollectionView)  {
        
        let string = global.imgurImageSearch
        let url = NSURL(string: string)
        let request = NSMutableURLRequest(url: url! as URL)
        request.setValue(global.imgurClientID, forHTTPHeaderField: "Authorization") //**
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        
        let mData = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if let res = response as? HTTPURLResponse {
                
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
                
                self.imgurGetImageURLs(gallery: galleryData, collectionView: collectionView)
                
                
            }else{
                print("Error: \(String(describing: error))")
            }
        }
        mData.resume()
        //        print(imgURLsArray) // <= RESOLVER PROBLEMA DE ASSINCRONISMO
    }
    
    
}
