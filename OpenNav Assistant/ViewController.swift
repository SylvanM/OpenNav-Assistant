//
//  ViewController.swift
//  OpenNav Assistant
//
//  Created by Sylvan Martin on 3/17/19.
//  Copyright © 2019 Sylvan Martin. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateProgressBar), name: .uploadedImageFragment, object: nil)

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    // MARK: Properties
    
    @IBOutlet weak var progressBar: NSProgressIndicator!
    
    // MARK: Actions
    
    @IBAction func uploadLayout(_ sender: Any) {
        
        let dialog = NSOpenPanel();
        
        dialog.title                    = "Choose a directory file";
        dialog.showsResizeIndicator     = true
        dialog.showsHiddenFiles         = true
        dialog.canChooseDirectories     = true
        dialog.canCreateDirectories     = false
        dialog.allowsMultipleSelection  = false
        dialog.defaultButtonCell?.title = "Upload"
        
        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            let result = dialog.url! // Pathname of directory
            
            let fileHelper = FileHelper(result)
            let request = fileHelper.getLayout()!
            print(request.code)
            let server = ServerCommunicator()
            server.uploadLayout(request)
            
        } else {
            // User clicked on "Cancel"
            return
        }
        
    }
    
    @IBAction func removeLayout(_ sender: Any) {
        
        let prompt = NSAlert()
        
        prompt.messageText = "Enter code"
        prompt.informativeText = "Enter the code of the layout you wish to delete"
        prompt.alertStyle = .warning
        prompt.addButton(withTitle: "Delete")
        prompt.addButton(withTitle: "Cancel")
        
        let field = NSTextField(frame: NSRect(x: 0, y: 0, width: 200, height: 24))
        field.stringValue = "";
        
        prompt.accessoryView = field
        
        // User pressed "Delete"
        if prompt.runModal() == .alertFirstButtonReturn {
            let server = ServerCommunicator()
            server.delete(layout: field.stringValue)
        }
        
    }
    
    // MARK: Observers
    
    @objc
    func updateProgressBar() {
        progressBar.doubleValue = percentImageFragmentsSent
    }
    
}

