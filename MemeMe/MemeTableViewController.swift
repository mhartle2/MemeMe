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
    
    //var completedMeme: Meme!
    
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
        
        let completedMeme = self.meme[(indexPath as NSIndexPath).row]
        
        let topText = completedMeme.topText
        let bottomText = completedMeme.bottomText
        cell.imageView?.image = completedMeme.memedImage
        cell.textLabel?.text = "\(topText) ... \(bottomText)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailViewController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailViewController.completedMeme = self.meme[indexPath.row]
        self.navigationController!.pushViewController(detailViewController, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.memes.remove(at: indexPath.row)
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.endUpdates()
            self.tableView.reloadData()
            
        }
        
    }
}
