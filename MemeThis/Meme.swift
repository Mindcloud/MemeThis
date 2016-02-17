//
//  Meme.swift
//  MemeThis
//
//  Created by Jeff Boschee on 2/16/16.
//  Copyright © 2016 Mindcloud. All rights reserved.
//

import Foundation
import UIKit

class Meme {
    var topText = ""
    var bottomText = ""
    var originalImage = UIImage()
    var memedImage = UIImage()
    
    init(topText: String, bottomText: String, originalImage: UIImage, memedImage: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.originalImage = originalImage
        self.memedImage = memedImage
    }
    
    
}