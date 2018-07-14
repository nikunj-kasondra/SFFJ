//
//  ChartdeController.swift
//  Sainte Famillie
//
//  Created by Rujal on 1/7/18.
//  Copyright © 2018 Nikunj. All rights reserved.
//

import UIKit

class ChartdeController: UIViewController {

    @IBOutlet weak var charteView: UIView!
    @IBOutlet weak var chartViewHeight: NSLayoutConstraint!
    @IBOutlet weak var webView: UIWebView!
    var presArr = NSArray()
    var htmlStr = String()
    @IBOutlet weak var ageListSpinner: LBZSpinner!
    var classId = String()
    var dropArr = NSArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        if let login = UserDefaults.standard.object(forKey: "AlreadyLogin"){
            print(login)
            let flag = UserDefaults.standard.object(forKey: "AlreadyLogin") as! String
            if flag == "S" {
                ageListSpinner.isHidden = true
                classId = UserDefaults.standard.value(forKey: "role") as! String
                chartViewHeight.constant = 0
                charteView.isHidden = true
                //settView.isHidden = false
                //myAcView.isHidden = false
                
            } else if flag == "P" {
                chartViewHeight.constant = 64
                charteView.isHidden = false
                ageListSpinner.isHidden = false
                let retriveArrayData = UserDefaults.standard.object(forKey:  "parentArr") as? NSData
                
                dropArr = (NSKeyedUnarchiver.unarchiveObject(with: retriveArrayData! as Data) as? NSArray)!
                self.ageListSpinner.updateList(dropArr.value(forKey: "FullName") as! [String])
                self.ageListSpinner.delegate = self
                self.ageListSpinner.text = (dropArr.value(forKey: "FullName") as! NSArray).object(at: 0) as! String
                classId = (dropArr.value(forKey: "ClassId") as! NSArray).object(at: 0) as! String
            } else if flag == "T" {
        
                classId = UserDefaults.standard.object(forKey: "Code") as! String
            }
        }

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
            var urlStr = ""
            let flag = UserDefaults.standard.object(forKey: "AlreadyLogin") as! String
            if flag == "S" {
                urlStr = "http://api.sainte-famille.edu.lb/api/login/getchartedevie?classId=\(classId)"
                
            } else if flag == "P" {
                urlStr = "http://api.sainte-famille.edu.lb/api/login/getchartedevie?classId=\(classId)"
            } else if flag == "T" {
                
                urlStr = "http://api.sainte-famille.edu.lb/api/login/getteacherchartedevie?userName=\(classId)"
            }

            let url = URL(string: urlStr)
            URLSession.shared.dataTask(with: url!, completionHandler: {
                (data, response, error) in
                if(error != nil){
                    Progress.hide(toView: self.view)
                    print("error")
                }else{
                    do{
                        self.presArr = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! NSArray
                        if let login = UserDefaults.standard.object(forKey: "AlreadyLogin"){
                            print(login)
                            let flag = UserDefaults.standard.object(forKey: "AlreadyLogin") as! String
                            if flag == "S" {
                                if self.presArr.count != 0 {
                                    for i in 0..<self.presArr.count {
                                        let dict = self.presArr.object(at: i) as! NSDictionary
                                        if dict.value(forKey: "slogan") as? String != nil {
                                            self.htmlStr += dict.value(forKey: "slogan") as! String
                                        }
                                        //                                if dict.value(forKey: "SectionName") as? String != nil {
                                        //                                    self.sectionName = dict.value(forKey: "SectionName") as! String
                                        //                                }
                                        
                                    }
                                    //self.lblPresent.isHidden = false
                                    
                                    
                                    
                                    self.webView.loadHTMLString(self.htmlStr, baseURL: nil)
                                    
                                }
                                
                            } else if flag == "P" {
                                if self.presArr.count != 0 {
                                    for i in 0..<self.presArr.count {
                                        let dict = self.presArr.object(at: i) as! NSDictionary
                                        if dict.value(forKey: "slogan") as? String != nil {
                                            self.htmlStr += dict.value(forKey: "slogan") as! String
                                        }
                                        //                                if dict.value(forKey: "SectionName") as? String != nil {
                                        //                                    self.sectionName = dict.value(forKey: "SectionName") as! String
                                        //                                }
                                        
                                    }
                                    //self.lblPresent.isHidden = false
                                    
                                    
                                    
                                    self.webView.loadHTMLString(self.htmlStr, baseURL: nil)
                                    
                                }
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

extension ChartdeController:UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        Progress.hide(toView: self.view)
        //self.lblPresent.text = self.sectionName
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        Progress.hide(toView: self.view)
    }
}
extension ChartdeController: LBZSpinnerDelegate {
    func spinnerChoose(_ spinner: LBZSpinner, index: Int, value: String) {
        print("Spinner : \(spinner) : { Index : \(index) - \(value) }")
        classId = (dropArr.value(forKey: "ClassId") as! NSArray).object(at: index) as! String
        self.callPresentation()
    }
}
