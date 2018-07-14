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
    
    @IBOutlet weak var btnImg: UIButton!
    // MARK: - Variables
    var itemIndex: Int = 0
    var imageName: String = "" {
        
        didSet {
            
            if let imageView = contentImageView {
                    let url1 = "http://sainte-famille.edu.lb/Upfiles/Photos/Large/" + imageName
                    imageView.kf.setImage(with: URL(string:url1), placeholder:UIImage(named:""), options: nil, progressBlock: nil, completionHandler:nil)
            }
            
        }
    }
    
    @IBOutlet var contentImageView: UIImageView?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        contentImageView!.image = UIImage(named: imageName)
        if NewsController.videoId == "" {
            let url1 = "http://sainte-famille.edu.lb/Upfiles/Photos/Large/" + imageName
            contentImageView?.kf.setImage(with: URL(string:url1), placeholder:UIImage(named:""), options: nil, progressBlock: nil, completionHandler:nil)
        } else {
            if itemIndex < NewsDetailController.finalCount - 1 {
                let url1 = "http://sainte-famille.edu.lb/Upfiles/Photos/Large/" + imageName
                contentImageView?.kf.setImage(with: URL(string:url1), placeholder:UIImage(named:""), options: nil, progressBlock: nil, completionHandler:nil)
            } else {
                let imageStr = (((imageName.components(separatedBy: "?") as! NSArray).object(at: 1) as! String).components(separatedBy: "=") as! NSArray).object(at: 1) as! String
                
                let url1 = "https://img.youtube.com/vi/\(imageStr)/0.jpg"
                contentImageView?.kf.setImage(with: URL(string:url1), placeholder:UIImage(named:""), options: nil, progressBlock: nil, completionHandler:nil)
            }
            
        }
        
    }
    
    
    @IBAction func btnImage(_ sender: Any) {
        
        let notificationName = Notification.Name("NotificationIdentifier")
        
        // Post notification
        NotificationCenter.default.post(name: notificationName, object: nil)
        
    }
}
