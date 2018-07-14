//
//  PresentationDetailController.swift
//  Sainte Famillie
//
//  Created by Rujal on 11/16/17.
//  Copyright © 2017 Nikunj. All rights reserved.
//

import UIKit

class PresentationDetailController: UIViewController {

    @IBOutlet weak var lblPresent: UILabel!
    @IBOutlet weak var webView: UIWebView!
    var presArr = NSArray()
    var sectionName = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        lblPresent.isHidden = true
        callPresentation()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
        func callPresentation() {
            if !Reachability.isConnectedToNetwork() {
                Alert.show("Sainte Famillie", message: "Please check your internet connection", onVC: self)
            } else {
                Progress.show(toView: self.view)
                let url = URL(string: "http://api.sainte-famille.edu.lb/api/Notrecollege")
                URLSession.shared.dataTask(with: url!, completionHandler: {
                    (data, response, error) in
                    if(error != nil){
                        Progress.hide(toView: self.view)
                        print("error")
                    }else{
                        do{
                            self.presArr = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! NSArray
                            var htmlStr = String()
                            
                            if self.presArr.count != 0 {
                                for i in 0..<self.presArr.count {
                                    let dict = self.presArr.object(at: i) as! NSDictionary
                                    if dict.value(forKey: "PageContent") as? String != nil {
                                        htmlStr += dict.value(forKey: "PageContent") as! String
                                    }
                                    if dict.value(forKey: "SectionName") as? String != nil {
                                        self.sectionName = dict.value(forKey: "SectionName") as! String
                                    }
                                    
                                    
                                }
                                
                                
                                
                                if htmlStr != "" {
                                    
                                    self.webView.loadHTMLString(htmlStr, baseURL: nil)
                                } else {
                                    self.lblPresent.isHidden = false
                                }
    
                            }
                        }catch let error as NSError{
                            print(error)
                            Alert.show("Sainte Famillie", message: "Something went wrong. Please try again", onVC: self)
                            Progress.hide(toView: self.view)
                        }
                    }
                }).resume()
                
            }
        }
}
extension PresentationDetailController:UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        Progress.hide(toView: self.view)
        DispatchQueue.main.async {
            self.lblPresent.isHidden = false
            self.lblPresent.text = self.sectionName
        }
    }
}

