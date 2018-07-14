//
//  LoginController.swift
//  Sainte Famillie
//
//  Created by Rujal on 12/8/17.
//  Copyright © 2017 Nikunj. All rights reserved.
//

import UIKit

class LoginController: UIViewController {

    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtUserName: UITextField!
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

    @IBAction func btnLoginClicked(_ sender: Any) {
        if txtUserName.text! == "" {
            Alert.show("Sainte Famillie", message: "Please enter username", onVC: self)
        } else if txtPassword.text! == "" {
            Alert.show("Sainte Famillie", message: "Please enter password", onVC: self)
        } else {
            if txtUserName.text?.characters.first == "E" {
                callLogin()
            } else if txtUserName.text?.characters.first == "F" {
                callEmployeeLogin()
            } else if txtUserName.text?.characters.first == "T" {
                callTeacherLogin()
            } else {
                Alert.show("Sainte Famillie", message: "Please enter valid username", onVC: self)
            }
            
        }
    }
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func callTeacherLogin() {
        if !Reachability.isConnectedToNetwork() {
            Alert.show("Sainte Famillie", message: "Please check your internet connection", onVC: self)
        } else {
            Progress.show(toView: self.view)
            let url = URL(string: "http://api.sainte-famille.edu.lb/api/login/getteahcerloginuserdetails?userName=\(txtUserName.text!)&password=\(txtPassword.text!)&deviceId=\(AppDelegate.deviceToken)")
            URLSession.shared.dataTask(with: url!, completionHandler: {
                (data, response, error) in
                if(error != nil){
                    Progress.hide(toView: self.view)
                    print("error")
                }else{
                    Progress.hide(toView: self.view)
                    do{
                        let dict = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! NSDictionary
                        if dict.value(forKey: "Password") as! String != self.txtPassword.text! {
                            Alert.show("Sainte Famillie", message: "Wrong username or password", onVC: self)
                        } else {
                            UserDefaults.standard.set("T", forKey: "AlreadyLogin")
                            UserDefaults.standard.set(self.txtUserName.text!, forKey: "Code")
                            if let name = dict.value(forKey: "FullName") as? String {
                                print(name)
                                UserDefaults.standard.set(name, forKey: "headerName")
                                UserDefaults.standard.set(dict.value(forKey: "FullName") as! String, forKey: "name")
                            }
                            if let name = dict.value(forKey: "Email1") as? String {
                                print(name)
                                UserDefaults.standard.set(dict.value(forKey: "Email1") as! String, forKey: "email")
                            }
                            if let name = dict.value(forKey: "Email2") as? String {
                                print(name)
                                UserDefaults.standard.set(dict.value(forKey: "Email2") as! String, forKey: "email2")
                            }
                            if let name = dict.value(forKey: "Mobile") as? String {
                                print(name)
                                UserDefaults.standard.set(dict.value(forKey: "Mobile") as! String, forKey: "mobile")
                            }
                            if let name = dict.value(forKey: "Phone") as? String {
                                print(name)
                                UserDefaults.standard.set(dict.value(forKey: "Phone") as! String, forKey: "phone")
                            }
                            if let roleName = dict.value(forKey: "ClassId") as? String {
                                print(roleName)
                                UserDefaults.standard.set(dict.value(forKey: "ClassId") as! String, forKey: "role")
                            }
                            let VC = Common.storyboard.instantiateViewController(withIdentifier: "DashboardController")
                            Navigation.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
                            //                            self.view.makeToast("Login successful")
                        }
                        print(dict)
                        
                    }catch let error as NSError{
                        print(error)
                        Alert.show("Sainte Famillie", message: "Something went wrong. Please try again", onVC: self)
                        Progress.hide(toView: self.view)
                    }
                }
            }).resume()
            
        }

    }
    
    func callLogin() {
        if !Reachability.isConnectedToNetwork() {
            Alert.show("Sainte Famillie", message: "Please check your internet connection", onVC: self)
        } else {
            Progress.show(toView: self.view)
            let url = URL(string: "http://api.sainte-famille.edu.lb/api/login/getloginuserdetails?userName=\(txtUserName.text!)&password=\(txtPassword.text!)&deviceId=\(AppDelegate.deviceToken)")
            URLSession.shared.dataTask(with: url!, completionHandler: {
                (data, response, error) in
                if(error != nil){
                    Progress.hide(toView: self.view)
                    print("error")
                }else{
                    Progress.hide(toView: self.view)
                    do{
                        let dict = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! NSDictionary
                        if dict.value(forKey: "Message") as! String == "User Not Exists." {
                            Alert.show("Sainte Famillie", message: "Wrong username or password", onVC: self)
                        } else {
                            if dict.value(forKey: "Password") as! String != self.txtPassword.text! {
                                Alert.show("Sainte Famillie", message: "Wrong username or password", onVC: self)
                            } else {
                                UserDefaults.standard.set("S", forKey: "AlreadyLogin")
                                UserDefaults.standard.set(self.txtUserName.text!, forKey: "Code")
                                if let name = dict.value(forKey: "FullName") as? String {
                                    print(name)
                                    UserDefaults.standard.set(dict.value(forKey: "FullName") as! String, forKey: "name")
                                    UserDefaults.standard.set(name, forKey: "headerName")
                                }
                                if let name = dict.value(forKey: "Email") as? String {
                                    print(name)
                                    UserDefaults.standard.set(dict.value(forKey: "Email") as! String, forKey: "email")
                                }
                                if let roleName = dict.value(forKey: "RoleName") as? String {
                                    print(roleName)
                                    UserDefaults.standard.set(dict.value(forKey: "ClassId") as! String, forKey: "role")
                                }
                                let VC = Common.storyboard.instantiateViewController(withIdentifier: "DashboardController")
                                Navigation.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
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
    
    func callEmployeeLogin() {
        if !Reachability.isConnectedToNetwork() {
            Alert.show("Sainte Famillie", message: "Please check your internet connection", onVC: self)
        } else {
            Progress.show(toView: self.view)
            
            let url = URL(string: "http://api.sainte-famille.edu.lb/api/login/getparentloginuserdetails?userName=\(txtUserName.text!)&password=\(txtPassword.text!)&deviceId=\(AppDelegate.deviceToken)")
            
            URLSession.shared.dataTask(with: url!, completionHandler: {
                (data, response, error) in
                if(error != nil){
                    Progress.hide(toView: self.view)
                    print("error")
                }else{
                    Progress.hide(toView: self.view)
                    do{
                        let dict = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! NSArray
                        if dict.count == 0 {
                            Alert.show("Sainte Famillie", message: "Wrong username or password", onVC: self)
                        }
//                        else if (dict.value(forKey: "Password") as! NSArray).object(at: 0) as! String != self.txtPassword.text! {
//                            Alert.show("Sainte Famillie", message: "Wrong username or password", onVC: self)
//                        }
                        else {
                            UserDefaults.standard.set("P", forKey: "AlreadyLogin")
                            UserDefaults.standard.set(self.txtUserName.text!, forKey: "Code")
                            let namesArrayData = NSKeyedArchiver.archivedData(withRootObject: dict)
                           UserDefaults.standard.set(namesArrayData, forKey: "parentArr")
                            //UserDefaults.standard.setValue(namesArrayData, forKey: "parentArr")
                            self.callPresentation()
                            
                            //                            self.view.makeToast("Login successful")
                        }
                        print(dict)
                        
                    }catch let error as NSError{
                        print(error)
                        Alert.show("Sainte Famillie", message: "Something went wrong. Please try again", onVC: self)
                        Progress.hide(toView: self.view)
                    }
                }
            }).resume()
            
        }
    }
    func callPresentation() {
        if !Reachability.isConnectedToNetwork() {
            Alert.show("Sainte Famillie", message: "Please check your internet connection", onVC: self)
        } else {
            Progress.show(toView: self.view)
            let url = URL(string: "http://api.sainte-famille.edu.lb/api/login/getparentlogindetails?userName=\(UserDefaults.standard.value(forKey: "Code") as! String)")
            URLSession.shared.dataTask(with: url!, completionHandler: {
                (data, response, error) in
                if(error != nil){
                    Progress.hide(toView: self.view)
                    print("error")
                }else{
                    
                    do{
                        let presArr = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! NSDictionary
                        Progress.hide(toView: self.view)
                        if presArr.count != 0 {
                            if presArr.value(forKey: "Password") as! String == self.txtPassword.text! {
                                if let headerName = presArr.value(forKey: "FullName") as? String {
                                    UserDefaults.standard.set(headerName, forKey: "headerName")
                                }
                                let VC = Common.storyboard.instantiateViewController(withIdentifier: "DashboardController")
                                Navigation.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
                            } else {
                                Alert.show("Sainte Famillie", message: "Wrong username or password", onVC: self)
                            }
                        } else {
                            Alert.show("Sainte Famillie", message: "Wrong username or password", onVC: self)
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

extension LoginController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if txtUserName == textField {
            txtPassword.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
