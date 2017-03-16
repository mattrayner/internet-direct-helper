//
//  StatusMenuController.swift
//  InternetDirectHelper
//
//  Created by RAYNER, Matthew on 16/03/2017.
//  Copyright © 2017 RAYNER, Matthew. All rights reserved.
//

import Cocoa
import Foundation

class StatusMenuController: NSObject {
    @IBOutlet weak var statusMenu: NSMenu!
    
    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    
    override func awakeFromNib() {
        let icon = NSImage(named: "statusIcon")
        icon?.isTemplate = true // best for dark mode
        statusItem.image = icon
        statusItem.menu = statusMenu
    }
    
    @IBAction func toggleWifiClicked(_ sender: NSMenuItem) {
        let bundle = Bundle.main
        let path = bundle.path(forResource: "toggle_wifi", ofType: "txt")
        
        if let filepath = path {
            do {
                let contents = try String(contentsOfFile: filepath)
                
                execute_apple_script(appleSctipt: contents)
            } catch {
                print("Could not load the applescript file toggle_wifi.scpt")
            }
        }
    }
    
    func execute_apple_script(appleSctipt: String) {
        var error: NSDictionary?
        if let scriptObject = NSAppleScript(source: appleSctipt) {
            if let output: NSAppleEventDescriptor = scriptObject.executeAndReturnError(
                &error) {
                print(output.stringValue ?? "No script output")
            } else if (error != nil) {
                print("error: \(error)")
            }
        }
    }
    
    @IBAction func openLoginClicked(_ sender: NSMenuItem) {
        if let url = URL(string: "http://internetdirect.parliament.uk/login.html"), NSWorkspace.shared().open(url) {
            print("default browser was successfully opened")
        }
        
    }
    
    @IBAction func quitClicked(sender: NSMenuItem) {
        NSApplication.shared().terminate(self)
    }
}
