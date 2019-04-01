//
//  ViewController.swift
//  OpenNav Assistant
//
//  Created by Sylvan Martin on 3/17/19.
//  Copyright © 2019 Sylvan Martin. All rights reserved.
//

import Cocoa

class FileViewController: NSViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var imageView: NSImageView!
    @IBOutlet var      textView:  NSTextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.isHidden = true
        textView.isHidden  = false

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    // MARK: Methods
    
    func displayImage(_ image: Image) {
        textView.isHidden  = true
        imageView.isHidden = false
        imageView.image = image
    }
    
    func displayFile(_ data: Data, encoding: String.Encoding) {
        imageView.isHidden = true
        textView.isHidden  = false
        
        if let displayText = String(data: data, encoding: encoding) {
            textView.string = displayText
        } else {
            textView.string = "Unable to load file"
        }
    }
    
    // MARK: Actions
    
    @IBAction func uploadLayout(_ sender: Any) {
        
        
        
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
    
}

