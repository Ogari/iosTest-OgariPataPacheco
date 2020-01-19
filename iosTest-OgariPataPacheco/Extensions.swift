//
//  MediaServices.swift
//  iosTest-OgariPataPacheco
//
//  Created by Ogari Pata Pacheco on 19/01/2020.
//  Copyright © 2020 Ogari Pata Pacheco. All rights reserved.
//

import Foundation
import AKVideoImageView

extension UIImageView {
    
    // Auxiliar function to download video to local repo - so I can play the movie
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
                    
                    let videoView = AKVideoImageView(frame: self.bounds, videoURL: fileURL as URL)!
                    self.addSubview(videoView)
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
