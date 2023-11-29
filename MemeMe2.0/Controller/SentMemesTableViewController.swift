//
//  SentMemesTableViewController.swift
//  MemeMe2.0
//
//  Created by Aye Nyein Nyein Su on 17/05/2023.
//

import UIKit

private let reuseIdentifier = "MemeTableViewCell"

class SentMemesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    // for shared model
    var memes: [Meme] {
    
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        return appDelegate.memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource  = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = false
        navigationController?.isNavigationBarHidden = false
        tableView.reloadData()
    }
    
    @IBAction func addPressed(_ sender: Any) {
        
        let memeController = storyboard!.instantiateViewController(withIdentifier: "MeMeViewController")
        //self.navigationController!.presentViewController(memeController, animated: true, completion: nil)
        navigationController?.isNavigationBarHidden = true
        tabBarController?.tabBar.isHidden = true
        self.navigationController!.pushViewController(memeController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return memes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MemeTableViewCell
        let sentMeme = memes[(indexPath as NSIndexPath).row]
        cell.sentMemeImage.image = sentMeme.memedImage
        cell.sentMemeLabel.text = sentMeme.topText + "..." + sentMeme.bottomText
        tableView.rowHeight = 100.0
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        controller.meme = memes[(indexPath as NSIndexPath).row]
        navigationController?.pushViewController(controller, animated: true)
        
    }

}
