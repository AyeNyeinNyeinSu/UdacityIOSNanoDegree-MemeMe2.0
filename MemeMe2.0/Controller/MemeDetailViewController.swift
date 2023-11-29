//
//  MemeDetailViewController.swift
//  MemeMe2.0
//
//  Created by Aye Nyein Nyein Su on 19/05/2023.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController {
    
    var meme: Meme!
    
    @IBOutlet weak var memedImage: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        memedImage.image = meme.memedImage
    }
    
}
