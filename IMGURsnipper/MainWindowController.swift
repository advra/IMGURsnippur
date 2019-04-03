//
//  MainWindowController.swift
//  ImgurSnipur
//
//  Created by Adrian de Vera Alonzo on 3/26/19.
//  Copyright © 2019 Adrian Alonzo. All rights reserved.
//

import Cocoa
import WebKit

class MainWindowController: NSWindowController, WKUIDelegate  {

    let imgurAPI = ImgurAPI()
    
    @IBOutlet weak var webViewer: WKWebView!
    
    override func windowDidLoad() {
        super.windowDidLoad()
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
//        let myUrl = URL(string: "https://api.imgur.com/oauth2/authorize?client_id=" + imgurAPI.CLIENT_ID + "&response_type=token&state=snipsuccess")
//        let myRequest = URLRequest(url: myUrl!)
//        webViewer.load(myRequest)
        
        let myURL = URL(string:"https://www.apple.com")
        let myRequest = URLRequest(url: myURL!)
        webViewer.load(myRequest)
//        webViewer.load(URLRequest(url: URL(string: "http://www.sourcefreeze.com")!))
    }

    @IBAction func signInButtonClicked(_ sender: NSButton) {
        print("Signed in")
        imgurAPI.authorizeUser()
    }

}
