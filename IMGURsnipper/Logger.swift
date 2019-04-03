//
//  Logger.swift
//  ImgurSnipur
//
//  Created by Adrian de Vera Alonzo on 4/1/19.
//  Copyright © 2019 Adrian Alonzo. All rights reserved.
//

import Cocoa

class Logger: NSObject {
    
    static func write(_ input: String){
        do{
            let out = URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("/Desktop/log.txt")
            try input.write(to: out, atomically: false, encoding: .utf8)
        }catch{
            print("Error writing to log file.")
        }
    }
}
