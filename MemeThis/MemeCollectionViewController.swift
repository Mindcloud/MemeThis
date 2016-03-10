//
//  MemeCollectionViewController.swift
//  MemeThis
//
//  Created by Jeff Boschee on 3/10/16.
//  Copyright © 2016 Mindcloud. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewController: UICollectionViewController{
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        collectionView!.reloadData()
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.allMemes.count
    }
    
    var allMemes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        if let meme = Meme.getAtIndex(indexPath.row) {
            cell.memeImageView.image = meme.memedImage
        }
        return cell
    }
}
