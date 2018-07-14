//
//  PublicationController.swift
//  Sainte Famillie
//
//  Created by Rujal on 11/29/17.
//  Copyright © 2017 Nikunj. All rights reserved.
//

import UIKit
import Kingfisher

class PublicationController: UIViewController {


    @IBOutlet weak var imgAuth: UIImageView!
    @IBOutlet weak var lblHtml: UILabel!
    @IBOutlet weak var lblHeader: UILabel!
    var sectionName = String()
    var htmlStr = String()
    var prodArr = NSArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        callProdAPI()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func callProdAPI() {
        if !Reachability.isConnectedToNetwork() {
            Alert.show("Sainte Famillie", message: "Please check your internet connection", onVC: self)
        } else {
            Progress.show(toView: self.view)
            let url = URL(string: "http://api.sainte-famille.edu.lb/api/pagedacceuil/getpublications")
            URLSession.shared.dataTask(with: url!, completionHandler: {
                (data, response, error) in
                
                if(error != nil){
                    Progress.hide(toView: self.view)
                    print("error")
                }else{
                    do{
                        self.prodArr = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! NSArray
                        var imageURL = String()
                        if self.prodArr.count != 0 {
                            for i in 0..<self.prodArr.count {
                                let dict = self.prodArr.object(at: i) as! NSDictionary
                                if dict.value(forKey: "Summary") as? String != nil {
                                    self.htmlStr += dict.value(forKey: "Summary") as! String
                                }
                                if dict.value(forKey: "Photo") as? String != nil {
                                    imageURL = dict.value(forKey: "Photo") as! String
                                }
                                if dict.value(forKey: "Title") as? String != nil {
                                    self.sectionName = dict.value(forKey: "Title") as! String
                                }
                                
                            }
                            DispatchQueue.main.async {
                                self.lblHeader.text = self.sectionName
                                let attrStr = try! NSAttributedString(
                                    data: self.htmlStr.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
                                    options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                                    documentAttributes: nil)
                                self.lblHtml.attributedText = attrStr
                                imageURL = String("http://sainte-famille.edu.lb/Upfiles/Photos/Small/") + String(imageURL)
                                
                                self.imgAuth.kf.setImage(with: URL(string:imageURL))
                                Progress.hide(toView: self.view)
                            }
                            
                        }
                    }
                    catch let error as NSError{
                        print(error)
                        Alert.show("Sainte Famillie", message: "Something went wrong. Please try again", onVC: self)
                        Progress.hide(toView: self.view)
                    }
                    
                }
            }).resume()
            
        }
    }

}

