//
//  StatusMenuController.swift
//  ImgurSnipur
//
//  Created by Adrian de Vera Alonzo on 3/26/19.
//  Copyright © 2019 Adrian Alonzo. All rights reserved.
//

import Cocoa
import Foundation

class StatusMenuController: NSObject {
    
    // Accessibility Enabled Bool
    var hasPrivacyAccess = false
    let imgurAPI = ImgurAPI()
    
    // Main Menu
    @IBOutlet weak var statusMenu: NSMenu!
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    // App Status Menu
    // This will update whther user is not signed in, signed in or on anonymous mode (uplaod without specific account). By default we are not signed in
    @IBOutlet weak var menuStatus: NSMenuItem!
    
    // Sign in Menu
    @IBOutlet weak var mainWindow: NSWindow!
    
    @IBAction func signInClicked(_ sender: NSMenuItem) {
        // bring app to front
        NSApp.activate(ignoringOtherApps: true)
        // order window layer to front
        mainWindow.makeKeyAndOrderFront(Any?.self)
    }
    
    // Settings Menu
    @IBAction func settingsClicked(_ sender: NSMenuItem) {
    }
    
    
    // Quit App from Menu
    @IBAction func quitAppClicked(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
    
    override func awakeFromNib() {
        // set the status icon
        let icon = NSImage(named: "statusIcon")
        icon?.isTemplate = true // best for dark mode otherwise comment out
        statusItem.image = icon
        statusItem.menu = statusMenu

        // check if user allowed app
        checkIfAllowedAccess()
        
        // TODO: Need to fix this bug that requires me to unapprove and reapprove app at each launch!
        // if not access then display prompt
        if(hasPrivacyAccess == false){
            let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String : true]
            let accessEnabled = AXIsProcessTrustedWithOptions(options)
        }
        
        // log global file input
        NSEvent.addGlobalMonitorForEvents(matching: [.keyDown]) { (event) in
            print(event.keyCode)
        
            if(event.modifierFlags.contains(.shift) && (event.modifierFlags.contains(.command))){
                if(event.keyCode == 50){    //Tilda
                    print("SCREENSHOT!")
                    self.screenshot()
                }
            }
        }
    }
    
    // Returns whether the app is added to users's list of Allowed Apps needed to log keystrokes in background
    public func checkIfAllowedAccess(){
        let options : NSDictionary = [kAXTrustedCheckOptionPrompt.takeRetainedValue() as NSString: false]
        let accessibilityEnabled = AXIsProcessTrustedWithOptions(options)
        hasPrivacyAccess = accessibilityEnabled
        print(hasPrivacyAccess)
    }
    
    // Upon startup, prompt for user permission to allow app to be added to privacy list. Needed to listen for keystrokes
    // in the backgroun.
    public func displayAllowAccessPrompt(){
        //Nudge user to add app to their privacy list
        let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String : true]
        let accessEnabled = AXIsProcessTrustedWithOptions(options)
        
        if accessEnabled == false {
            print("Access Not Enabled")
        }
    }
    
    // Screen shot in background is triggered
    func screenshot(){
        let windowImage: CGImage = CGWindowListCreateImage(CGRect.infinite, .optionAll, kCGNullWindowID, .nominalResolution)!
        
        func CreateTimeStamp() -> Int32
        {
            return Int32(Date().timeIntervalSince1970)
        }
        
        func getDateAndTime()->String{
            let currentDateTime = Date()
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            formatter.dateStyle = .short
            return formatter.string(from: currentDateTime)
        }

        let unixTimestamp = CreateTimeStamp()
        let date = getDateAndTime()
        let filename = NSHomeDirectory()
        var paths = NSSearchPathForDirectoriesInDomains(.desktopDirectory, .userDomainMask, true) as [String]
        let fileURL = URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("Desktop/screenshot_\(unixTimestamp).png")
        print(fileURL.path)
        
        let bitmapRep = NSBitmapImageRep(cgImage: windowImage)
        let jpegData = bitmapRep.representation(using: NSBitmapImageRep.FileType.png, properties: [:])!
        
        do {
            try jpegData.write(to: fileURL, options: .atomic)
        } catch  {
            print("error: \(error)")
        }
        
        // Debug output to file
//        imgurAPI.uploadFile(fileURL)
        imgurAPI.uploadEncodedImage(windowImage)
    }
    
}
