//
//  ReglementController.swift
//  Sainte Famillie
//
//  Created by Rujal on 1/3/18.
//  Copyright © 2018 Nikunj. All rights reserved.
//

import UIKit

class ReglementController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    var prodArr = NSArray()
    var htmlStr = String()
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
            let url = URL(string: "http://api.sainte-famille.edu.lb/api/login/getreglementdelecole?sectionsId=59")
            URLSession.shared.dataTask(with: url!, completionHandler: {
                (data, response, error) in
                
                if(error != nil){
                    Progress.hide(toView: self.view)
                    print("error")
                }else{
                    do{
                        self.prodArr = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! NSArray
                        if self.prodArr.count != 0 {
                            for i in 0..<self.prodArr.count {
                                let dict = self.prodArr.object(at: i) as! NSDictionary
                                if dict.value(forKey: "PageContent") as? String != nil {
                                    self.htmlStr += dict.value(forKey: "PageContent") as! String
                                }
                                
                            }
                            DispatchQueue.main.async {
                                
//                                let attrStr = try! NSAttributedString(
//                                    data: self.htmlStr.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
//                                    options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
//                                    documentAttributes: nil)
//                                self.lblHtml.attributedText = attrStr
                                self.webView.loadHTMLString(self.htmlStr, baseURL: nil)
                                
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

extension ReglementController:UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        //Progress.hide(toView: self.view)
        Progress.hide(toView: self.view)
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        Progress.hide(toView: self.view)
    }
}
