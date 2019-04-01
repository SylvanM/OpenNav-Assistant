//
//  BrowserViewController.swift
//  OpenNav Assistant
//
//  Created by Sylvan Martin on 3/30/19.
//  Copyright © 2019 Sylvan Martin. All rights reserved.
//

import Cocoa

class BrowserViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    
    // MARK: Properties
    
    public var selectedFile: URL {
        return tableViewData[tableView.selectedRow].1
    }

    var tableViewData: [(String, URL)] {
        
        guard let url = directory else {
            return []
        }
        
        let fileHelper = FileHelper(url)
        do {
            if let names = try fileHelper.getFiles() {
                return names.1
            } else {
                return []
            }
        } catch {
            return []
        }
        
    }
    
    @IBOutlet weak var tableView: NSTableView!
    
    // MARK: View Controller

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        notificationCenter.addObserver(self, selector: #selector(update), name: Notification.directoryURLSet.name, object: nil)
    }
    
    // MARK: Observers
    
    @objc
    func update() {
        tableView.reloadData()
    }
    
    // MARK: Data source
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return tableViewData[row].0
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        notificationCenter.post(.newFileToView)
    }
    
    
}
