//
//  ListResultsTableView.swift
//  Tip Calcly
//
//  Created by Abdalrahim Abdullah on 12/7/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import Foundation
import UIKit

class ListResultsTableView: UITableView {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    // 2
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("listNotesTableViewCell", forIndexPath: indexPath)
        
        
        cell.textLabel?.text = "Yay - it's working!"
        
        return cell
    }
}