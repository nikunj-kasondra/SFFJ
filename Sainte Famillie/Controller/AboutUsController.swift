//
//  AboutUsController.swift
//  Sainte Famillie
//
//  Created by Rujal on 1/20/18.
//  Copyright © 2018 Nikunj. All rights reserved.
//

import UIKit

class AboutUsController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAppLinkClicked(_ sender: Any) {
        UIApplication.shared.openURL(URL(string: "http://www.compu-vision.me")!)
    }
    
    
    @IBAction func btnLogoClicked(_ sender: Any) {
        UIApplication.shared.openURL(URL(string: "http://sainte-famille.edu.lb/")!)
    }
}
