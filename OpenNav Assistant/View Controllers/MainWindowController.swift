//
//  MainWindowController.swift
//  OpenNav Assistant
//
//  Created by Sylvan Martin on 3/26/19.
//  Copyright © 2019 Sylvan Martin. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController, NSTouchBarDelegate {
    
    // MARK: Properties and Outlets
    
    @IBOutlet weak var uploadButton: NSButton!
    @IBOutlet weak var activityIndicator: NSProgressIndicator!
    @IBOutlet weak var pathView: NSPathControl!
    
    @IBOutlet weak var uploadTouchBar: NSTouchBar!
    
    
    // MARK: View Controller
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        self.window?.title = "OpenNav Assistant Editor"
        
        if let code = layoutCode {
            self.window?.title = code
        }
        
        pathView.url = directory
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        
        notificationCenter.addObserver(self, selector: #selector(updatePathView), name: Notification.directoryURLSet.name, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(startActivityIndicator), name: Notification.startActivity.name, object: nil)
        notificationCenter.addObserver(self, selector: #selector(stopActivityIndicator),  name: Notification.stopActivity.name,  object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(doUpload), name: Notification.beginUpload.name, object: nil)
    }
    
    // MARK: Obj-C Functions
    
    @objc
    func updatePathView() {
        pathView.url = directory
        if let code = layoutCode {
            self.window?.title = code
        }
    }
    
    @objc
    func startActivityIndicator() {
        activityIndicator.startAnimation(nil)
    }
    
    @objc
    func stopActivityIndicator() {
        activityIndicator.stopAnimation(nil)
    }
    
    @objc
    func doUpload() {
        if !(UserDefaults.standard.string(forKey: "username") != nil && UserDefaults.standard.string(forKey: "password") != nil) {
            let alert = NSAlert()
            alert.messageText = "You are not logged in!"
            alert.runModal()
            return
        }
        
        notificationCenter.post(.startActivity)
        
        do {
            guard let url = directory else {
                throw FileUploadError.noDirectory
            }
            
            let fileHelper = FileHelper(url)
            let request = try fileHelper.getLayout()
            print(request.code)
            let server = ServerCommunicator()
            server.uploadLayout(request) { response in
                notificationCenter.post(.stopActivity)
            }
        } catch {
            self.presentError(error)
        }
    }
    
    // MARK: Actions
    
    @IBAction func upload(_ sender: Any? = nil) {
        notificationCenter.post(.beginUpload)
    }
    
    
    @IBAction func userPressedUploadTouchBarButton(_ sender: Any) {
        notificationCenter.post(.beginUpload)
    }
    
    // MARK: Touch bar
    
    override func makeTouchBar() -> NSTouchBar? {
        return uploadTouchBar
    }
    
    
    /// Error for uploading file
    enum FileUploadError: Error {
        case noDirectory
    }
}
