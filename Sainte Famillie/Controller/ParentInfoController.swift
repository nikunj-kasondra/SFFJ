//
//  ParentInfoController.swift
//  Sainte Famillie
//
//  Created by Rujal on 1/11/18.
//  Copyright © 2018 Nikunj. All rights reserved.
//

import UIKit

class ParentInfoController: UIViewController {
    
    @IBOutlet weak var txtNouveau: UITextField!
    @IBOutlet weak var txtAncien: UITextField!
    @IBOutlet weak var lblCode1: UILabel!
    @IBOutlet weak var lblCode: UILabel!
    @IBOutlet weak var txtEmail2Du: UITextField!
    @IBOutlet weak var txtEmail1Du: UITextField!
    @IBOutlet weak var txtCelDu: UITextField!
    @IBOutlet weak var txtNomDu: UITextField!
    @IBOutlet weak var txtPrenomDu: UITextField!
    @IBOutlet weak var txtEmail2: UITextField!
    @IBOutlet weak var txtEmail1: UITextField!
    @IBOutlet weak var txtCelDe: UITextField!
    @IBOutlet weak var txtNom: UITextField!
    @IBOutlet weak var txtPrenom: UITextField!
    var presArr = NSDictionary()
    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        lblCode.text = UserDefaults.standard.value(forKey:"Code") as! String
        lblCode1.text = UserDefaults.standard.value(forKey:"Code") as! String
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
            let url = URL(string: "http://api.sainte-famille.edu.lb/api/login/getparentlogindetails?userName=\(UserDefaults.standard.value(forKey: "Code") as! String)")
            URLSession.shared.dataTask(with: url!, completionHandler: {
                (data, response, error) in
                if(error != nil){
                    Progress.hide(toView: self.view)
                    print("error")
                }else{
                    
                    do{
                        self.presArr = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! NSDictionary
                        DispatchQueue.main.async {
                            self.txtPrenom.text = self.presArr.value(forKey: "MotherFName") as? String
                            self.txtNom.text = self.presArr.value(forKey: "MotherLName") as? String
                            self.txtCelDe.text = self.presArr.value(forKey: "MotherMobile") as? String
                            self.txtEmail1.text = self.presArr.value(forKey: "MotherEmail1") as? String
                            self.txtEmail2.text = self.presArr.value(forKey: "MotherEmail2") as? String
                            self.txtEmail2.text = self.presArr.value(forKey: "MotherEmail2") as? String
                            self.txtPrenomDu.text = self.presArr.value(forKey: "FatherFName") as? String
                            self.txtNomDu.text = self.presArr.value(forKey: "FatherLName") as? String
                            self.txtCelDu.text = self.presArr.value(forKey: "FatherMobile") as? String
                            self.txtEmail1Du.text = self.presArr.value(forKey: "FatherEmail1") as? String
                            self.txtEmail2Du.text = self.presArr.value(forKey: "FatherEmail2") as? String
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

    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnPassModifier(_ sender: Any) {
    
        if !Reachability.isConnectedToNetwork() {
            Alert.show("Sainte Famillie", message: "Please check your internet connection", onVC: self)
        } else {
            Progress.show(toView: self.view)
            let url : String = "http://api.sainte-famille.edu.lb/api/login/getparetmodifiermotdepasse?userName=\(UserDefaults.standard.value(forKey: "Code")as! String)&Ancienmotdepasse=\(txtAncien.text!)&Nouveaumotdepasse=\(txtNouveau.text!)"
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
                            self.txtAncien.text = ""
                            self.txtNouveau.text = ""
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
            let url : String = "http://api.sainte-famille.edu.lb/api/login/getparentpersonnelinfo?userName=\(UserDefaults.standard.value(forKey: "Code")as! String)&Prenomdelamere=\(txtPrenom.text!)&Nomdelamere=\(txtNom.text!)&Celdelamere=\(txtCelDe.text!)&Email1delamere=\(txtEmail1.text!)&Email2delamere=\(txtEmail2.text!)&Prenomdupere=\(txtPrenomDu.text!)&Nomdupere=\(txtNomDu.text!)&Celdupere=\(txtCelDu.text!)&Email1dupere=\(txtEmail1Du.text!)&Email2dupere=\(txtEmail2Du.text!)"
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
extension ParentInfoController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if txtCelDe == textField {
            txtEmail1.becomeFirstResponder()
        } else if txtEmail1 == textField {
            txtEmail2.becomeFirstResponder()
        } else if txtEmail2 == textField {
            txtCelDu.becomeFirstResponder()
        } else if txtCelDu == textField {
            txtEmail1Du.becomeFirstResponder()
        } else if txtEmail1Du == textField {
            txtEmail2Du.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
