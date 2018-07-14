//
//  PersonnelInfoController.swift
//  Sainte Famillie
//
//  Created by Rujal on 1/4/18.
//  Copyright © 2018 Nikunj. All rights reserved.
//

import UIKit

class PersonnelInfoController: UIViewController {

    @IBOutlet weak var txtEmail2: UITextField!
    @IBOutlet weak var txtEmail1: UITextField!
    @IBOutlet weak var lblCode1: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var lblCode: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        lblCode.text = UserDefaults.standard.value(forKey: "Code") as? String
        lblCode1.text = UserDefaults.standard.value(forKey: "Code") as? String
        txtEmail.text = UserDefaults.standard.value(forKey: "email") as? String
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnMotDe(_ sender: Any) {
        if !Reachability.isConnectedToNetwork() {
            Alert.show("Sainte Famillie", message: "Please check your internet connection", onVC: self)
        } else {
            Progress.show(toView: self.view)
            let url : String = "http://api.sainte-famille.edu.lb/api/login/getparetmodifiermotdepasse?userName=\(UserDefaults.standard.value(forKey: "Code")as! String)&Ancienmotdepasse=\(txtEmail1.text!)&Nouveaumotdepasse=\(txtEmail2.text!)"
            let urlStr : String = url.addingPercentEscapes(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
            let url1 = URL(string:urlStr)
            URLSession.shared.dataTask(with: url1!, completionHandler: {
                (data, response, error) in
                if(error != nil){
                    Progress.hide(toView: self.view)
                    print("error")
                }else{
                    
                    do{
                        let arr = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! NSArray
                        let dict = arr.object(at: 0) as! NSDictionary
                        if arr.count != 0 {
                            Alert.show("SFFJ", message: dict.value(forKey: "Message") as! String, onVC: self)
                        } else {
                            Alert.show("SFFJ", message:"Please try again", onVC: self)
                            
                        }
                        DispatchQueue.main.async {
                            self.txtEmail1.text = ""
                            self.txtEmail2.text = ""
                        }
                        
                        Progress.hide(toView: self.view)
                    }catch let error as NSError{
                        print(error)
                        Alert.show("Sainte Famillie", message: "Something went wrong. Please try again", onVC: self)
                        Progress.hide(toView: self.view)
                    }
                }
            }).resume()
        }

    }
    @IBAction func btnModifierEmail(_ sender: Any) {
        
            if !Reachability.isConnectedToNetwork() {
            Alert.show("Sainte Famillie", message: "Please check your internet connection", onVC: self)
        } else {
            Progress.show(toView: self.view)
            let url : String = "http://api.sainte-famille.edu.lb/api/login/getpersonnelinfo?userName=\(UserDefaults.standard.value(forKey: "Code")as! String)&emailId=\(txtEmail.text!)"
            let urlStr : String = url.addingPercentEscapes(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
            let url1 = URL(string:urlStr)
            URLSession.shared.dataTask(with: url1!, completionHandler: {
                (data, response, error) in
                if(error != nil){
                    Progress.hide(toView: self.view)
                    print("error")
                }else{
                    
                    do{
                        let arr = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! NSArray
                        let dict = arr.object(at: 0) as! NSDictionary
                        UserDefaults.standard.set(self.txtEmail.text!, forKey: "email")
                        if arr.count != 0 {
                            Alert.show("SFFJ", message: dict.value(forKey: "Message") as! String, onVC: self)
                        } else {
                            Alert.show("SFFJ", message:"Please try again", onVC: self)
                            
                        }
                        Progress.hide(toView: self.view)
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
extension PersonnelInfoController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
