//
//  AnnoncesDetailVC.swift
//  Sainte Famillie
//
//  Created by Rujal on 2/26/18.
//  Copyright © 2018 Nikunj. All rights reserved.
//

import UIKit
import Kingfisher

class AnnoncesDetailVC: UIViewController {

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblHtml: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lblHeader: UILabel!
    static var imgStr = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        let attrStr1 = try! NSAttributedString(
            data: NewsDetailController.Header.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
            options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
            documentAttributes: nil)
        lblHeader.attributedText = attrStr1
        let attrStr2 = try! NSAttributedString(
            data: NewsDetailController.Detail.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
            options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
            documentAttributes: nil)
        lblDetail.attributedText = attrStr2
        lblDate.text = NewsDetailController.Date
        let attrStr = try! NSAttributedString(
            data: NewsDetailController.Summary.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
            options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
            documentAttributes: nil)
        self.lblHtml.attributedText = attrStr
        if NewsController.videoId != "" {
            let imageStr = (((NewsController.videoId.components(separatedBy: "?") as! NSArray).object(at: 1) as! String).components(separatedBy: "=") as! NSArray).object(at: 1) as! String
            
            let url1 = "https://img.youtube.com/vi/\(imageStr)/0.jpg"
            img?.kf.setImage(with: URL(string:url1), placeholder:UIImage(named:""), options: nil, progressBlock: nil, completionHandler:nil)
        } else {
            img.kf.setImage(with: URL(string:AnnoncesDetailVC.imgStr))
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
       self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnImgClicked(_ sender: Any) {
        if NewsController.videoId != "" {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "YoutubeVC")
            self.navigationController?.pushViewController(VC!, animated: false)
        }
        else if AnnoncesDetailVC.imgStr != "" {
            let VC = Common.storyboard.instantiateViewController(withIdentifier: "AnnoncesImagesVC")
            Navigation.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
        }
    }
    
}
