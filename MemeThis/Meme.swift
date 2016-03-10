//
//  Meme.swift
//  MemeThis
//
//  Created by Jeff Boschee on 2/18/16.
//  Copyright © 2016 Mindcloud. All rights reserved.
//

import Foundation
import UIKit

class Meme {
    var topText = ""
    var bottomText = ""
    var original = UIImage()
    var memedImage = UIImage()
    
    init(topText: String, bottomText: String, original: UIImage, memedImage: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.original = original
        self.memedImage = memedImage
    }
    
    func save() {
        // Add it to the memes array in the Application Delegate
        Meme.myStore().memes.append(self)
    }
    
    // Get storage for memes
    class func myStore() -> AppDelegate {
        let object = UIApplication.sharedApplication().delegate
        return object as! AppDelegate
    }
    
    // Get Count of all Memes
    class func countAll() -> Int {
        return Meme.myStore().memes.count
    }
    
    // Get One Meme
    class func getAtIndex(index: Int) -> Meme? {
        if Meme.myStore().memes.count > index {
            return Meme.myStore().memes[index]
        }
        return nil
    }
}