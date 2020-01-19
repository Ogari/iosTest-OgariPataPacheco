//
//  ViewController.swift
//  iosTest-OgariPataPacheco
//
//  Created by Ogari Pata Pacheco on 18/01/2020.
//  Copyright © 2020 Ogari Pata Pacheco. All rights reserved.
//

import UIKit
import AKVideoImageView

extension UIImageView {
    
    // Auxiliar function to download video to local repo - so I can play the movie
    func downloadVideo(url: URL)
    {
//        let urlString = "http://www.sample-videos.com/video/mp4/720/big_buck_bunny_720p_1mb.mp4"
        
        DispatchQueue.global(qos: .default).async(execute: {
            //All stuff here
            
            print("Downloading video...");
//            let url=NSURL(string: urlString);
            let urlData=NSData(contentsOf: url as URL);
            
            if((urlData) != nil)
            {
                let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
                
//                let fileName = urlString as NSString;
                let fileName = url.absoluteString as NSString;
                
                let filePath="\(documentsPath)/\(fileName.lastPathComponent)";
                
                let fileExists = FileManager().fileExists(atPath: filePath)
                
                if(fileExists){
                    // File is already downloaded
                    print("Video file already downloaded!")
                }
                else{
                    //Download
                    DispatchQueue.main.async(execute: { () -> Void in
                        print("Will save on following path...")
                        print(filePath)
                        urlData?.write(toFile: filePath, atomically: true);
                        print("videoSaved");
                        
                        // Searches the URL and tries to play it
                        let fileURL = NSURL.init(fileURLWithPath: filePath)
//                        let request = NSURLRequest.init(url: fileURL as URL)
                        
                        let videoView = AKVideoImageView(frame: self.bounds, videoURL: fileURL as URL)!
                        self.addSubview(videoView)
                        
                    })
                }
            }
        })
    }
    
    
    
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else {
                    print("ERROR: Could not convert the downloaded file from the link given to an image!")
                    
                    let imageExtensions = ["jpg", "jpeg", "png", "gif"]
                    // Iterate & match the URL objects from your checking results
                    let pathExtention = url.pathExtension
                    if !(imageExtensions.contains(pathExtention))
                    {
                        print("Movie URL: \(String(describing: url))")
                        //                    let url = Bundle.main.url(forResource: "video_1", withExtension: "mp4")!
                        DispatchQueue.main.async() {
                            self.downloadVideo(url: url)
                        }
                    }
                    return
                    }
            DispatchQueue.main.async() {
                let imageExtensions = ["jpg", "jpeg", "png", "gif"]
                // Iterate & match the URL objects from your checking results
                let pathExtention = url.pathExtension
                if imageExtensions.contains(pathExtention)
                {
                    print("Image URL: \(String(describing: url))")
                    self.image = image
                }
//                else
//                {
//                    print("Movie URL: \(String(describing: url))")
////                    let url = Bundle.main.url(forResource: "video_1", withExtension: "mp4")!
//                    let videoView = AKVideoImageView(frame: self.bounds, videoURL: url)!
//                    self.addSubview(videoView)
//                }
                
                
//                self.image = image
                
            }
            }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}


//struct Imgur: Decodable {
//
//}


class ViewController: UIViewController, UICollectionViewDataSource {
    var imgURLsArray : [String] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        
//        let url = URL(string: "https://api.imgur.com/3/gallery/search/?q=cats")
//        URLSession.shared.dataTask(with: url!) { (data, response, err) in
//            if err == nil {
//
//            }
//
//        }.resume()
        
        
        
        
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
