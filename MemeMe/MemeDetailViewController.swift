//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Marc on 5/5/17.
//  Copyright © 2017 Marc. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    var meme: [Meme]{
        get {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            return appDelegate.memes
        }
        
    }
    
    var completedMeme: Meme!
    
    @IBOutlet var image: UIImageView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.image.image = self.completedMeme.memedImage
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
}
