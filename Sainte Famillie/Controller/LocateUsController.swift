//
//  LocateUsController.swift
//  Sainte Famillie
//
//  Created by Rujal on 12/8/17.
//  Copyright © 2017 Nikunj. All rights reserved.
//

import UIKit

class LocateUsController: UIViewController {

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
    
    @IBAction func btnMapClicked(_ sender: Any) {
        UIApplication.shared.openURL(URL(string: "https://www.google.com/maps/@33.983209,35.63253,17z?hl=en-US")!)
    }
    
    
}
