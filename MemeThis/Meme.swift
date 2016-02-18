//
//  Meme.swift
//  MemeThis
//
//  Created by Jeff Boschee on 2/18/16.
//  Copyright © 2016 Mindcloud. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
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
}