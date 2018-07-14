//
//  ProdDetailController.swift
//  Sainte Famillie
//
//  Created by Rujal on 11/29/17.
//  Copyright © 2017 Nikunj. All rights reserved.
//

import UIKit

class ProdDetailController: UIViewController {

    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var webView: UIWebView!
    static var prod1Id = NSNumber()
    var prodArr = NSArray()
    var sectionName = String()
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
            let url = URL(string: "http://api.sainte-famille.edu.lb/api/pagedacceuil/getproductionsdeselevesstudentsarticlesbyid?classCategoryId=\(ProdDetailController.prod1Id)")
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
                                if dict.value(forKey: "Details") as? String != nil {
                                    self.htmlStr += dict.value(forKey: "Details") as! String
                                }
                                if dict.value(forKey: "Title") as? String != nil {
                                    self.sectionName = dict.value(forKey: "Title") as! String
                                }
                                
                            }
                            DispatchQueue.main.async {
                                self.lblHeader.text = self.sectionName
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

extension ProdDetailController: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        Progress.hide(toView: self.view)
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        Progress.hide(toView: self.view)
    }
}
