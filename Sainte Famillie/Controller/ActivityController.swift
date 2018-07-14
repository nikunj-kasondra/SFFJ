


//
//  ActivityController.swift
//  Sainte Famillie
//
//  Created by Rujal on 11/19/17.
//  Copyright © 2017 Nikunj. All rights reserved.
//

import UIKit

class ActivityController: UIViewController {
    
    @IBOutlet weak var scrlView: UIScrollView!
    @IBOutlet weak var lbl3: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var btnListe: UIButton!
    @IBOutlet weak var btnInsc: UIButton!
    @IBOutlet weak var btnPres: UIButton!
    @IBOutlet weak var lblPres: UILabel!
    @IBOutlet weak var listeView: UIWebView!
    @IBOutlet weak var presView: UIWebView!
    
    @IBOutlet weak var inscView: UIWebView!
    var presArr = NSArray()
    var sectionName = String()
    var htmlStr = String()
    var insArr = NSArray()
    var insSectionName = String()
    var insHtmlStr = String()
    var regionArr = NSArray()
    var regionSectionName = String()
    var regionHtmlStr = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        lbl1.isHidden = false
        lbl2.isHidden = true
        lbl3.isHidden = true
        lblPres.isHidden = true
        presView.isHidden = false
        listeView.isHidden = true
        inscView.isHidden = true
        //regionView.scalesPageToFit = true
        btnInsc.setTitleColor(UIColor.init(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.5), for: .normal)
        btnListe.setTitleColor(UIColor.init(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.5), for: .normal)
        btnPres.setTitleColor(UIColor.init(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0), for: .normal)
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
    
    @IBAction func btnPresentationClicked(_ sender: Any) {
        lbl1.isHidden = false
        lbl2.isHidden = true
        lbl3.isHidden = true
        presView.isHidden = false
        listeView.isHidden = true
        inscView.isHidden = true
        btnInsc.setTitleColor(UIColor.init(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.5), for: .normal)
        btnListe.setTitleColor(UIColor.init(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.5), for: .normal)
        btnPres.setTitleColor(UIColor.init(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0), for: .normal)
        scrlView.contentOffset = CGPoint(x: 0, y: 0)
        if sectionName != "" {
            lblPres.text = sectionName
        }
    }
    
    @IBAction func btnListeClicked(_ sender: Any) {
        lbl1.isHidden = true
        lbl2.isHidden = true
        lbl3.isHidden = false
        presView.isHidden = true
        listeView.isHidden = false
        inscView.isHidden = true
        btnInsc.setTitleColor(UIColor.init(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.5), for: .normal)
        btnListe.setTitleColor(UIColor.init(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0), for: .normal)
        btnPres.setTitleColor(UIColor.init(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.5), for: .normal)
        let newContentOffsetX: CGFloat = (scrlView.contentSize.width - scrlView.frame.size.width) / 2
        scrlView.contentOffset = CGPoint(x: newContentOffsetX, y: 0)
        if regionSectionName != "" {
            lblPres.text = regionSectionName
        } 
    }
    
    @IBAction func btnInscriptionClicked(_ sender: Any) {
        lbl1.isHidden = true
        lbl2.isHidden = false
        lbl3.isHidden = true
        presView.isHidden = true
        listeView.isHidden = true
        inscView.isHidden = false
        btnInsc.setTitleColor(UIColor.init(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0), for: .normal)
        btnListe.setTitleColor(UIColor.init(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.5), for: .normal)
        btnPres.setTitleColor(UIColor.init(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.5), for: .normal)
        scrlView.contentOffset = CGPoint(x: scrlView.contentSize.width - UIScreen.main.bounds.size.width, y: 0)
        if insSectionName != "" {
            lblPres.text = insSectionName
        }
    }
    
    func callPresentation() {
        if !Reachability.isConnectedToNetwork() {
            Alert.show("Sainte Famillie", message: "Please check your internet connection", onVC: self)
        } else {
            Progress.show(toView: self.view)
            let url = URL(string: "http://api.sainte-famille.edu.lb/api/servicesauxiliaires/getactivitesextrascolairespresentation")
            URLSession.shared.dataTask(with: url!, completionHandler: {
                (data, response, error) in
                if(error != nil){
                    Progress.hide(toView: self.view)
                    print("error")
                }else{
                    do{
                        self.presArr = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! NSArray
                        self.callInsp()
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
                                //self.lblPres.isHidden = false
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
    
    func callInsp() {
        if !Reachability.isConnectedToNetwork() {
            Alert.show("Sainte Famillie", message: "Please check your internet connection", onVC: self)
        } else {
            Progress.show(toView: self.view)
            let url = URL(string: "http://api.sainte-famille.edu.lb/api/servicesauxiliaires/getactivitesextrascolairesinscriptions")
            URLSession.shared.dataTask(with: url!, completionHandler: {
                (data, response, error) in
                if(error != nil){
                    Progress.hide(toView: self.view)
                    print("error")
                }else{
                    do{
                        self.insArr = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! NSArray
                        self.callRegion()
                        if self.insArr.count != 0 {
                            for i in 0..<self.insArr.count {
                                let dict = self.insArr.object(at: i) as! NSDictionary
                                if dict.value(forKey: "PageContent") as? String != nil {
                                    self.insHtmlStr += dict.value(forKey: "PageContent") as! String
                                }
                                if dict.value(forKey: "SectionName") as? String != nil {
                                    self.insSectionName = dict.value(forKey: "SectionName") as! String
                                }
                                
                            }
                            if self.insHtmlStr != "" {
                                self.inscView.loadHTMLString(self.insHtmlStr, baseURL: nil)
                            } else {
                                //self.lblPres.isHidden = false
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
    
    
    func callRegion() {
        if !Reachability.isConnectedToNetwork() {
            Alert.show("Sainte Famillie", message: "Please check your internet connection", onVC: self)
        } else {
            Progress.show(toView: self.view)
            let url = URL(string: "http://api.sainte-famille.edu.lb/api/servicesauxiliaires/getactivitesextrascolairesliste")
            URLSession.shared.dataTask(with: url!, completionHandler: {
                (data, response, error) in
                Progress.hide(toView: self.view)
                if(error != nil){
                    Progress.hide(toView: self.view)
                    print("error")
                }else{
                    do{
                        self.regionArr = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! NSArray
                        
                        if self.regionArr.count != 0 {
                            for i in 0..<self.regionArr.count {
                                let dict = self.regionArr.object(at: i) as! NSDictionary
                                if dict.value(forKey: "PageContent") as? String != nil {
                                    self.regionHtmlStr += dict.value(forKey: "PageContent") as! String
                                }
                                if dict.value(forKey: "SectionName") as? String != nil {
                                    self.regionSectionName = dict.value(forKey: "SectionName") as! String
                                }
                                
                            }
                            if self.regionHtmlStr != "" {
                                self.listeView.loadHTMLString(self.regionHtmlStr, baseURL: nil)
                            } else {
                                //self.lblPres.isHidden = false
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

extension ActivityController:UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        //Progress.hide(toView: self.view)
        if webView == presView {
            DispatchQueue.main.async {
                self.lblPres.isHidden = false
                self.lblPres.text = self.sectionName
            }
        }
    }
}

