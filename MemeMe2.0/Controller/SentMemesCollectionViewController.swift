//
//  SentMemesCollectionViewController.swift
//  MemeMe2.0
//
//  Created by Aye Nyein Nyein Su on 17/05/2023.
//

import UIKit

private let reuseIdentifier = "MemeCollectionViewCell"

class SentMemesCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    @IBOutlet var memeCollectionView: UICollectionView!
    
    
    // for shared model
    var memes: [Meme] {
    
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        return appDelegate.memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        memeCollectionView.delegate = self
        memeCollectionView.dataSource = self
        
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0

        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        memeCollectionView.reloadData()
    }
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        
        let memeController = storyboard!.instantiateViewController(withIdentifier: "MeMeViewController")
        navigationController?.isNavigationBarHidden = true
        tabBarController?.tabBar.isHidden = true
        self.navigationController!.pushViewController(memeController, animated: true)
    }
    
    

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MemeCollectionViewCell
        let sentMeme = memes[(indexPath as NSIndexPath).row]
        cell.sentMemeImage.image = sentMeme.memedImage

        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let controller = storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        controller.meme = memes[(indexPath as NSIndexPath).row]
        navigationController?.pushViewController(controller, animated: true)
    }
    

}
