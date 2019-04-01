//
//  MenuController.swift
//  OpenNav Assistant
//
//  Created by Sylvan Martin on 3/26/19.
//  Copyright © 2019 Sylvan Martin. All rights reserved.
//

import Cocoa

class MenuController: NSMenu {
    
    // MARK: - Account

    // MARK: Properties
    
    let server = ServerCommunicator()
    
    @IBOutlet var loginButton:  NSMenuItem!
    @IBOutlet var createButton: NSMenuItem!
    @IBOutlet var logoutButton: NSMenuItem!
    
    // FILE Menu Items
    
    @IBOutlet var newFile:  NSMenuItem!
    @IBOutlet var openFile: NSMenuItem!
    
    
    // MARK: Actions
    
    @IBAction func login(_ sender: Any?) {
        let passField   = NSSecureTextField(frame: NSRect(x: 0, y: 2, width: 250, height: 20))
        let unameField  = NSTextField(frame: NSRect(x: 0, y: 28, width: 250, height: 20))
        let stackViewer = NSStackView(frame: NSRect(x: 0, y: 0, width: 200, height: 58))
        
        stackViewer.addSubview(unameField)
        stackViewer.addSubview(passField)
        
        let prompt = NSAlert()
        prompt.messageText = "Please enter your username and password"
        prompt.alertStyle = .warning
        
        prompt.addButton(withTitle: "Login")
        prompt.addButton(withTitle: "Cancel")
        prompt.accessoryView = stackViewer
        
        let response = prompt.runModal()
        
        if response == .alertFirstButtonReturn {
            let username = unameField.stringValue
            let password = passField.stringValue
            notificationCenter.post(.startActivity)
            login(username: username, password: password)
        }
    }
    
    @IBAction func create(_ sender: Any?) {
        let passField   = NSSecureTextField(frame: NSRect(x: 0, y: 2, width: 250, height: 20))
        let unameField  = NSTextField(frame: NSRect(x: 0, y: 28, width: 250, height: 20))
        let stackViewer = NSStackView(frame: NSRect(x: 0, y: 0, width: 200, height: 58))
        
        stackViewer.addSubview(passField)
        stackViewer.addSubview(unameField)
        
        let prompt = NSAlert()
        prompt.messageText = "Please enter the username and password you wish to create"
        prompt.alertStyle = .warning
        
        prompt.addButton(withTitle: "Create and Login")
        prompt.addButton(withTitle: "Cancel")
        prompt.accessoryView = stackViewer
        
        let response = prompt.runModal()
        
        if response == .alertFirstButtonReturn {
            let username = unameField.stringValue
            let password = passField.stringValue
            server.createAccount(username: username, password: password) { response in
                notificationCenter.post(.startActivity)
                if response != "" {
                    let alert = NSAlert()
                    alert.messageText = response
                    alert.runModal()
                }
                self.login(username: username, password: password)
            }
        }
    }
    
    @IBAction func logout(_ sender: Any?) {
        UserDefaults.standard.set(nil, forKey: "username")
        UserDefaults.standard.set(nil, forKey: "passsword")
    }
    
    // MARK: File Actions
    
    @IBAction func newFile(_ sender: Any?) {
        
    }
    
    @IBAction func openFile(_ sender: Any?) {
        let dialog = NSOpenPanel();
        
        dialog.title                    = "Choose a directory";
        dialog.showsResizeIndicator     = true
        dialog.showsHiddenFiles         = false
        dialog.canChooseDirectories     = true
        dialog.canCreateDirectories     = false
        dialog.allowsMultipleSelection  = false
        dialog.defaultButtonCell?.title = "Open"
        
        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            let result = dialog.url! // Pathname of directory
            
            // first, save it!
            directory = result
            
        } else {
            // User clicked on "Cancel"
            return
        }
    }
    
    @IBAction func closeFile(_ sender: Any?) {
        directory = nil
    }
    
    
    // MARK: Methods
    
    func login(username: String, password: String) {
        server.verifyAccount(username: username, password: password) { (isValidLogin) in
            switch isValidLogin {
            case true:
                UserDefaults.standard.set(username, forKey: "username")
                UserDefaults.standard.set(password, forKey: "password")
            case false:
                let errorAlert = NSAlert()
                errorAlert.messageText = "Could not log in"
                errorAlert.runModal()
            }
            notificationCenter.post(.stopActivity)
        }
    }
}
