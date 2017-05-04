//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Marc on 5/3/17.
//  Copyright © 2017 Marc. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {

    var meme: [Meme] {
        get {
            let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
            
            return appDelegate.memes
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func goToMemeEditor(_ sender: Any) {
        performSegue(withIdentifier: "goToEditorVC", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.meme.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let listMeme = self.meme[(indexPath as NSIndexPath).row]
        
        let topText = listMeme.topText
        let bottomText = listMeme.bottomText
        cell.imageView?.image = listMeme.memedImage
        cell.textLabel?.text = "\(topText) ... \(bottomText)"
        
        return cell
    }
    
}
