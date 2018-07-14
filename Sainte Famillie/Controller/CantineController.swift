//
//  CantineController.swift
//  Sainte Famillie
//
//  Created by Rujal on 11/18/17.
//  Copyright © 2017 Nikunj. All rights reserved.
//

import UIKit

class CantineController: UIViewController {

    @IBOutlet weak var lblPres: UILabel!
    @IBOutlet weak var MenuView: UIWebView!
    @IBOutlet weak var presView: UIWebView!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var btnDuMenu: UIButton!
    @IBOutlet weak var btnPresentation: UIButton!
    var presArr = NSArray()
    var sectionName = String()
    var htmlStr = String()
    var menuArr = NSArray()
    var menuSectionName = String()
    var menuHtmlStr = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        lbl1.isHidden = false
        lbl2.isHidden = true
        self.lblPres.isHidden = true
        btnDuMenu.setTitleColor(UIColor.init(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.5), for: .normal)
        btnPresentation.setTitleColor(UIColor.init(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0), for: .normal)
        MenuView.isHidden = true
        presView.isHidden = false
        callPresentation()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func callPresentation() {
        if !Reachability.isConnectedToNetwork() {
            Alert.show("Sainte Famillie", message: "Please check your internet connection", onVC: self)
        } else {
            Progress.show(toView: self.view)
            let url = URL(string: "http://api.sainte-famille.edu.lb/api/servicesauxiliaires/getpresentation")
            URLSession.shared.dataTask(with: url!, completionHandler: {
                (data, response, error) in
                if(error != nil){
                    Progress.hide(toView: self.view)
                    print("error")
                }else{
                    do{
                        self.presArr = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! NSArray
                        self.callMenuDU()
                        if self.presArr.count != 0 {
                            for i in 0..<self.presArr.count {
                                let dict = self.presArr.object(at: i) as! NSDictionary
                                if dict.value(forKey: "PageContent") as? String != nil {
                                    self.htmlStr += dict.value(forKey: "PageContent") as! String
                                }
                                if dict.value(forKey: "SectionName") as? String != nil {
                                    self.sectionName = dict.value(forKey: "SectionName") as! String
                                }
                                
                            }
                            if self.htmlStr != "" {
                                self.presView.loadHTMLString(self.htmlStr, baseURL: nil)
                            } else {
                                self.lblPres.isHidden = false
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
    
    func callMenuDU() {
        if !Reachability.isConnectedToNetwork() {
            Alert.show("Sainte Famillie", message: "Please check your internet connection", onVC: self)
        } else {
            Progress.show(toView: self.view)
            let url = URL(string: "http://api.sainte-famille.edu.lb/api/servicesauxiliaires/getmenudumois")
            URLSession.shared.dataTask(with: url!, completionHandler: {
                (data, response, error) in
                if(error != nil){
                    Progress.hide(toView: self.view)
                    print("error")
                }else{
                    do{
                        self.menuArr = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! NSArray
                        
                        if self.menuArr.count != 0 {
                            for i in 0..<self.menuArr.count {
                                let dict = self.menuArr.object(at: i) as! NSDictionary
                                if dict.value(forKey: "PageContent") as? String != nil {
                                    self.menuHtmlStr += dict.value(forKey: "PageContent") as! String
                                }
                                if dict.value(forKey: "SectionName") as? String != nil {
                                    self.menuSectionName = dict.value(forKey: "SectionName") as! String
                                }
                                
                            }
                            if self.menuHtmlStr != "" {
                                self.MenuView.loadHTMLString(self.menuHtmlStr, baseURL: nil)
                            } else {
                                self.lblPres.isHidden = false
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


    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnDUMenuClicked(_ sender: Any) {
        lbl1.isHidden = true
        presView.isHidden = true
        MenuView.isHidden = false
        lbl2.isHidden = false
        btnPresentation.setTitleColor(UIColor.init(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.5), for: .normal)
        btnDuMenu.setTitleColor(UIColor.init(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0), for: .normal)
        if menuSectionName != "" {
            self.lblPres.text = menuSectionName
        }
    }
    @IBAction func btnPresentationClicked(_ sender: Any) {
        lbl1.isHidden = false
        presView.isHidden = false
        MenuView.isHidden = true
        lbl2.isHidden = true
        btnDuMenu.setTitleColor(UIColor.init(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.5), for: .normal)
        btnPresentation.setTitleColor(UIColor.init(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0), for: .normal)
        if sectionName != "" {
            self.lblPres.text = sectionName
        }
    }
}

extension CantineController:UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        Progress.hide(toView: self.view)
        if webView == presView {
            DispatchQueue.main.async {
                self.lblPres.isHidden = false
                self.lblPres.text = self.sectionName
            }
        } else {
            DispatchQueue.main.async {
                self.lblPres.isHidden = false
                self.lblPres.text = self.sectionName
            }
        }
       
    }
}

