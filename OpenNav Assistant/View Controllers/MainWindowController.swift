//
//  MainWindowController.swift
//  OpenNav Assistant
//
//  Created by Sylvan Martin on 3/26/19.
//  Copyright © 2019 Sylvan Martin. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {
    
    // MARK: Properties and Outlets
    
    @IBOutlet weak var uploadButton: NSButton!
    
    // MARK: View Controller
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        self.window?.title = "OpenNav Assistant Editor"
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
    // MARK: Actions
    
    @IBAction func upload(_ sender: Any) {
        
        if !(UserDefaults.standard.string(forKey: "username") != nil && UserDefaults.standard.string(forKey: "password") != nil) {
            let alert = NSAlert()
            alert.messageText = "You are not logged in!"
            alert.runModal()
            return
        }
    
        let dialog = NSOpenPanel();
        
        dialog.title                    = "Choose a directory";
        dialog.showsResizeIndicator     = true
        dialog.showsHiddenFiles         = true
        dialog.canChooseDirectories     = true
        dialog.canCreateDirectories     = false
        dialog.allowsMultipleSelection  = false
        dialog.defaultButtonCell?.title = "Upload"
        
        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            let result = dialog.url! // Pathname of directory
            
            do {
                let fileHelper = FileHelper(result)
                let request = try fileHelper.getLayout()
                print(request.code)
                let server = ServerCommunicator()
                server.uploadLayout(request)
            } catch {
                self.presentError(error)
            }
            
        } else {
            // User clicked on "Cancel"
            return
        }
    }
}
