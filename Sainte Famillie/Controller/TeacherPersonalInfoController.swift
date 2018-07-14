//
//  TeacherPersonalInfoController.swift
//  Sainte Famillie
//
//  Created by Rujal on 1/18/18.
//  Copyright © 2018 Nikunj. All rights reserved.
//

import UIKit

class TeacherPersonalInfoController: UIViewController {

    @IBOutlet weak var email1: UITextField!
    @IBOutlet weak var email2: UITextField!
    @IBOutlet weak var lblCode1: UILabel!
    @IBOutlet weak var lblCode: UILabel!
    @IBOutlet weak var celDu: UITextField!
    @IBOutlet weak var cel: UITextField!
    @IBOutlet weak var pass1: UITextField!
    @IBOutlet weak var pass2: UITextField!
    
    var presArr = NSDictionary()
    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        lblCode.text = UserDefaults.standard.value(forKey: "Code") as? String
        lblCode1.text = UserDefaults.standard.value(forKey: "Code") as? String
        email1.text = UserDefaults.standard.value(forKey: "email") as? String
        email2.text = UserDefaults.standard.value(forKey: "email2") as? String
        cel.text = UserDefaults.standard.value(forKey: "mobile") as? String
        celDu.text = UserDefaults.standard.value(forKey: "phone") as? String
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnPassModifier(_ sender: Any) {
        
        if !Reachability.isConnectedToNetwork() {
            Alert.show("Sainte Famillie", message: "Please check your internet connection", onVC: self)
        } else {
            Progress.show(toView: self.view)
            
            let url : String = "http://api.sainte-famille.edu.lb/api/login/getteachermodifiermotdepasse?userName=\(UserDefaults.standard.value(forKey: "Code")as! String)&Ancienmotdepasse=\(pass1.text!)&Nouveaumotdepasse=\(pass2.text!)"
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
                            self.pass1.text = ""
                            self.pass2.text = ""
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
    @IBAction func btnParentModifier(_ sender: Any) {
        if !Reachability.isConnectedToNetwork() {
            Alert.show("Sainte Famillie", message: "Please check your internet connection", onVC: self)
        } else {
            Progress.show(toView: self.view)
            
            let url : String = "http://api.sainte-famille.edu.lb/api/login/getteacherpersonnelinfo?userName=\(UserDefaults.standard.value(forKey: "Code")as! String)&email1=\(email1.text!)&email2=\(email2.text!)&tel=\(celDu.text!)&cel=\(cel.text!)"
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
                        if arr.count != 0 {
                            UserDefaults.standard.set(self.email1.text!, forKey: "email")
                            UserDefaults.standard.set(self.email2.text!, forKey: "email2")
                            UserDefaults.standard.set(self.cel.text!, forKey: "mobile")
                            UserDefaults.standard.set(self.celDu.text!, forKey: "phone")
                            Alert.show("SFFJ", message:"Profile updated sucessfully", onVC: self)
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
extension TeacherPersonalInfoController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if email1 == textField {
            email2.becomeFirstResponder()
        } else if email2 == textField {
            celDu.becomeFirstResponder()
        } else if celDu == textField {
            cel.becomeFirstResponder()
        } else if cel == textField {
            cel.resignFirstResponder()
        } else if pass1 == textField {
            pass2.becomeFirstResponder()
        } else if pass2 == textField {
            pass2.resignFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
