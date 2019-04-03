//
//  ImgurAPI.swift
//  ImgurSnipur
//
//  Created by Adrian de Vera Alonzo on 3/26/19.
//  Copyright © 2019 Adrian Alonzo. All rights reserved.
//  https://localhost:814480

import Cocoa

class ImgurAPI: NSObject {
    
    let refreshToken = ""
    let clientToken = ""
    let BASE_URL = "https://api.imgur.com/"
    let username = ""
    
    var request : URLRequest?
    var session : URLSession?
    
    // Check if user is logged in (will use their key)
    func authorizeUser(){
        if username.isEmpty{
            print ("Not logged in")
            if let url = URL(string: "https://api.imgur.com/oauth2/authorize?client_id=" + Keys.CLIENT_ID + "&response_type=token&state=snipsuccess"),
                NSWorkspace.shared.open(url) {
                print("default browser was successfully opened")
            }
        }
    }
    
    // Take our image data and convert it to base64 string required by IMGUR api
    func imageToBase64String(_ cgImage: CGImage) -> String? {
        let imageRep = NSBitmapImageRep(cgImage: cgImage).representation(using: NSBitmapImageRep.FileType.png, properties: [:])
        let base64Image:String = ((imageRep!.base64EncodedString()))
        Logger.write(base64Image)
        return base64Image
    }
    
    // When user screenshots and allows file to be saved (default to desktop) then upload that
    func uploadScreenshot(_ file: URL){
        uploadFile(file)
    }
    
    // Upload with reference to a file on drive
    func uploadFile(_ file: URL){
        print("Path: \(file.path)")
        
        //get binary data from file
        let img = NSImage.init(contentsOf: file)
        let data = NSBitmapImageRep.representationOfImageReps(in: img!.representations, using: NSBitmapImageRep.FileType.png, properties: [:])
        
        // Create our url
        let url = URL(string: "https://api.imgur.com/3/image")!
        let request = NSMutableURLRequest.init(url: url)
        request.httpMethod = "POST"
        request.addValue("Client-ID " + Keys.CLIENT_ID, forHTTPHeaderField: "Authorization")
        
        // build our multiform
        let boundary = NSUUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let body = NSMutableData()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image\"\r\n\r\n".data(using: .utf8)!)
        body.append(data!)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body as Data
        
        // Begin the session request
        let task = URLSession.shared.dataTask(with: request as URLRequest){ data, response, error in
            if (error != nil){
                print("error: \(error)")
                return
            }
            
            print("response: \(response!)")
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("response string: \(responseString!)")
            
            //            let jsonData = try? JSONSerialization.data(withJSONObject: data, options: []) as? [String:Any]
            //            let postID = jsonData!["data"] as! String
            //            print(postID)
        }
        task.resume()
    }
    
    // Upload binary image data directly
    func uploadEncodedImage(_ image: CGImage){
        
        // Convert the file to base64
        let base64Image:String = imageToBase64String(image)!
        
        // Create our url
        let url = URL(string: "https://api.imgur.com/3/image")!
        let request = NSMutableURLRequest.init(url: url)
        request.httpMethod = "POST"
        request.addValue("Client-ID " + Keys.CLIENT_ID, forHTTPHeaderField: "Authorization")
        
        // Build our multiform and add our base64 image
        let boundary = NSUUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let body = NSMutableData()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image\"\r\n\r\n".data(using: .utf8)!)
        body.append(base64Image.data(using: .utf8)!)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body as Data
        
        // Begin the session request
        let task = URLSession.shared.dataTask(with: request as URLRequest){ data, response, error in
            if (error != nil){
                print("error: \(error)")
                return
            }
            
            print("response: \(response!)")
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("response string: \(responseString!)")
            
        }
        task.resume()
    }
    
    
}
