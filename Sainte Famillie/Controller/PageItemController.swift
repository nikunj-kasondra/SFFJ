//
//  PageItemController.swift
//  Paging_Swift
//
//  Created by olxios on 26/10/14.
//  Copyright (c) 2014 swiftiostutorials.com. All rights reserved.
//

import UIKit
import Kingfisher
class PageItemController: UIViewController {
    
    // MARK: - Variables
    var itemIndex: Int = 0
    var imageName: String = "" {
        
        didSet {
            
            if let imageView = contentImageView {
                    let url1 = "http://aamchit.com/images/news/" + imageName
                    imageView.kf.setImage(with: URL(string:url1), placeholder:UIImage(named:""), options: nil, progressBlock: nil, completionHandler:nil)
            }
            
        }
    }
    
    @IBOutlet var contentImageView: UIImageView?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        contentImageView!.image = UIImage(named: imageName)
        let url1 = Tab1Image.link + imageName
        contentImageView?.kf.setImage(with: URL(string:url1), placeholder:UIImage(named:""), options: nil, progressBlock: nil, completionHandler:nil)
    }
}
