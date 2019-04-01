//
//  SplitViewController.swift
//  OpenNav Assistant
//
//  Created by Sylvan Martin on 3/26/19.
//  Copyright © 2019 Sylvan Martin. All rights reserved.
//

import Cocoa

class SplitViewController: NSSplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        notificationCenter.addObserver(self, selector: #selector(reloadView), name: Notification.directoryURLSet.name, object: nil)
        notificationCenter.addObserver(self, selector: #selector(showNewFile), name: Notification.newFileToView.name, object: nil)
    }
    
    // MARK: Notification Observers
    
    @objc
    func showNewFile() {
        print("Showing file")
        do {
            let data = try Data(contentsOf: (splitViewItems.first?.viewController as! BrowserViewController).selectedFile)
            (splitViewItems[1].viewController as! FileViewController).displayFile(data, encoding: .ascii)
        } catch {
            print(error)
        }
    }
    
    @objc
    func reloadView() {
        print("reloaded!")
    }
    
}
