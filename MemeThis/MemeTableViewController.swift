//
//  MemeTableViewController.swift
//  MemeThis
//
//  Created by Jeff Boschee on 2/29/16.
//  Copyright © 2016 Mindcloud. All rights reserved.
//

import Foundation
import UIKit

class MemeTableViewController: UITableViewController{
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allMemes.count
    }
    
    var allMemes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell") as! MemeTableViewCell
        if let meme = Meme.getAtIndex(indexPath.row) {
            cell.imageView!.image = meme.memedImage
            cell.textLabel!.text = "\(meme.topText) ... \(meme.bottomText)"
        }
        return cell
    }
}
