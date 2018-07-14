//
//  AnnocesDetailController.swift
//  Sainte Famillie
//
//  Created by Rujal on 12/21/17.
//  Copyright © 2017 Nikunj. All rights reserved.
//

import UIKit

class AnnocesDetailController: UIViewController {
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblSubject: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    
    static var Id = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        callLivreAPI()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func callLivreAPI() {
        if !Reachability.isConnectedToNetwork() {
            Alert.show("Sainte Famillie", message: "Please check your internet connection", onVC: self)
        } else {
            Progress.show(toView: self.view)
            
            
            let url = URL(string: "http://api.sainte-famille.edu.lb/api/login/getannoncescements?id=\(AnnocesDetailController.Id)")
            URLSession.shared.dataTask(with: url!, completionHandler: {
                (data, response, error) in
                
                if(error != nil){
                    Progress.hide(toView: self.view)
                    print("error")
                }else{
                    do{
                        let livreArr = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! NSArray
                        if livreArr.count != 0 {
                            let htmlStr = (livreArr.value(forKey: "Subject") as! NSArray).object(at: 0) as? String
                            let attrStr = try! NSAttributedString(
                                data: (htmlStr?.data(using: String.Encoding.unicode, allowLossyConversion: true)!)!,
                                options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                                documentAttributes: nil)
                            self.lblSubject.attributedText = attrStr
                            let dateArr = ((livreArr.value(forKey: "rDate") as! NSArray).object(at: 0) as? String)?.components(separatedBy: "T")
                            let date = dateArr?[0].components(separatedBy: "-")
                            self.lblDate.text = (date?[2])! + "/" + (date?[1])! + "/" + (date?[0])!
                            let htmlStr1 = (livreArr.value(forKey: "Details") as! NSArray).object(at: 0) as? String
                            let attrStr1 = try! NSAttributedString(
                                data: (htmlStr1?.data(using: String.Encoding.unicode, allowLossyConversion: true)!)!,
                                options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                                documentAttributes: nil)
                            self.lblDesc.attributedText = attrStr1
                            Progress.hide(toView: self.view)
                        } else {
                            Progress.hide(toView: self.view)
                            self.lblSubject.text = "No Data Found"
                        }
                        print(livreArr)
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
