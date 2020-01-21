//
//  MediaServices.swift
//  iosTest-OgariPataPacheco
//
//  Created by Ogari Pata Pacheco on 19/01/2020.
//  Copyright © 2020 Ogari Pata Pacheco. All rights reserved.
//

import Foundation
import AKVideoImageView

enum StorageType {
    case userDefaults
    case fileSystem
}

extension UIImageView {
    
    // Auxiliar function to download videos and images to local repo - so I can play the movie and resize both of them
    func downloadVideo(url: URL)
    {
        //        let urlString = "http://www.sample-videos.com/video/mp4/720/big_buck_bunny_720p_1mb.mp4"
        
        DispatchQueue.global(qos: .default).async(execute: {
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
                
                // IMPROVE CODE REPETITION! (from "videoView onwards")
                if(fileExists){
                    // File is already downloaded
                    print("Video file already downloaded!")
                    // Searches the URL and tries to play it
                    let fileURL = NSURL.init(fileURLWithPath: filePath)
                    //                        let request = NSURLRequest.init(url: fileURL as URL)
                    DispatchQueue.main.async {
                        let videoView = AKVideoImageView(frame: self.bounds, videoURL: fileURL as URL)!
                        self.addSubview(videoView)
                    }
//                    self.addSubview(videoView)
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
    
    
//    func downloadImage(url: URL)
//    {
//        DispatchQueue.global(qos: .default).async(execute: {
//            print("Downloading image...");
//            //            let url=NSURL(string: urlString);
//            let urlData=NSData(contentsOf: url as URL);
//
//            if((urlData) != nil)
//            {
//                let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
//
//                //                let fileName = urlString as NSString;
//                let fileName = url.absoluteString as NSString;
//
//                let filePath="\(documentsPath)/\(fileName.lastPathComponent)";
//
//                let fileExists = FileManager().fileExists(atPath: filePath)
//
//                // IMPROVE CODE REPETITION!
//                if(fileExists){
//                    // File is already downloaded
//                    print("Image file already downloaded!")
//                    // Searches the URL and tries to show it
//                    let fileURL = NSURL.init(fileURLWithPath: filePath)
//                    //                        let request = NSURLRequest.init(url: fileURL as URL)
//
//                    self.image = UIImage(named: fileName as String)
////                    AKVideoImageView(
//
//                }
//                else{
//                    //Download
//                    DispatchQueue.main.async(execute: { () -> Void in
//                        print("Will save on following path...")
//                        print(filePath)
//                        urlData?.write(toFile: filePath, atomically: true);
//                        print("image saved");
//
//                        // Searches the URL and tries to play it
//                        let fileURL = NSURL.init(fileURLWithPath: filePath)
//                        //                        let request = NSURLRequest.init(url: fileURL as URL)
//
//                        self.image = UIImage(named: fileName as String)
////                        let videoView = AKVideoImageView(frame: self.bounds, videoURL: fileURL as URL)!
////                        self.addSubview(videoView)
//
//                    })
//                }
//            }
//        })
//    }
    
    private func storeImage(image: UIImage, forKey key: String, withStorageType storageType: StorageType) {
        print("A")
        if let pngRepresentation = image.pngData() {
            print("B")
            switch storageType {
            case .fileSystem: break
            // Save to disk
            case .userDefaults:
                UserDefaults.standard.set(pngRepresentation, forKey: key)
            }
            if let imageData = UserDefaults.standard.object(forKey: key) as? Data,
                let img = UIImage(data: imageData) {
                print(imageData)
                print(img)
                print(image)
                print("C")
                self.image = img
            }

        }
    }
    
    private func retrieveImage(forKey key: String, inStorageType storageType: StorageType) -> UIImage?  {
        switch storageType {
        case .fileSystem: break
        // Retrieve image from disk
        case .userDefaults:
            if let imageData = UserDefaults.standard.object(forKey: key) as? Data,
                let image = UIImage(data: imageData) {
                
                return image
            }
        }
        
        return nil
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
                    
//                    self.image = image
//                    self.downloadImage(url: url)
                    
                    self.storeImage(image: image, forKey: url.absoluteString, withStorageType: StorageType.userDefaults)
                    
                    
                }
                
            }
            }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
