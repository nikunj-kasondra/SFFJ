//
//  AnciensController.swift
//  Sainte Famillie
//
//  Created by Rujal on 9/27/17.
//  Copyright © 2017 Nikunj. All rights reserved.
//

import UIKit
import Alamofire

class AnciensController: UIViewController,LBZSpinnerDelegate {

    @IBOutlet weak var lblSinmsg: UILabel!
    @IBOutlet weak var lblPresentation: UILabel!
    @IBOutlet weak var txtMsg: UITextView!
    @IBOutlet weak var txtTel32: UITextField!
    @IBOutlet weak var txtTel31: UITextField!
    @IBOutlet weak var txtVille2: UITextField!
    @IBOutlet weak var txtSociete1: UITextField!
    @IBOutlet weak var txtProfession1: UITextField!
    @IBOutlet weak var txtTel22: UITextField!
    @IBOutlet weak var txtTel11: UITextField!
    @IBOutlet weak var txtVille1: UITextField!
    @IBOutlet weak var txtSociete: UITextField!
    @IBOutlet weak var txtProfession: UITextField!
    @IBOutlet weak var txtSecEmail: UITextField!
    @IBOutlet weak var txtPrimaryEmail: UITextField!
    @IBOutlet weak var txtTel2: UITextField!
    @IBOutlet weak var txtTel1: UITextField!
    @IBOutlet weak var txtCellulaire: UITextField!
    @IBOutlet weak var txtImmeuble: UITextField!
    @IBOutlet weak var txtQuartier: UITextField!
    @IBOutlet weak var txtVille: UITextField!
    @IBOutlet weak var txtPrenomConjoint: UITextField!
    @IBOutlet weak var txtNomConjoint: UITextField!
    var htmlStr = String()
    var sectionName = String()
    @IBOutlet weak var btnSin: UIButton!
    @IBOutlet weak var btnPresentation: UIButton!
    @IBOutlet weak var EtatCivilView: LBZSpinner!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var lblEtatCivil: UILabel!
    @IBOutlet weak var txtClasse: UITextField!
    @IBOutlet weak var txtPromotion: UITextField!
    @IBOutlet weak var txtDate: UILabel!
    @IBOutlet weak var txtPreNom: UITextField!
    @IBOutlet weak var txtNom: UITextField!
    @IBOutlet weak var txtCode: UITextField!
    @IBOutlet weak var insiseScrl: UIScrollView!
    @IBOutlet weak var presentationScrl: UIScrollView!
    @IBOutlet weak var lblInscrire: UILabel!
    @IBOutlet weak var lblPresent: UILabel!
    var presArr = NSArray()
    var regStr = NSMutableAttributedString()
    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        let listCode = ["Celibataire","Marriè","Veuf","Divorcè"]
        self.lblPresent.isHidden = true
        EtatCivilView.updateList(listCode)
        EtatCivilView.delegate = self
        lblEtatCivil.text = "Celibataire"
        btnSin.setTitleColor(UIColor.init(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.5), for: .normal)
        callRegistrationDetail()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        SideMenuView.btnIndex = 1
        SideMenuView.add(toVC: self, toView: self.view)
        presentationScrl.isHidden = false
        lblPresentation.isHidden = false
        lblInscrire.isHidden = true
        insiseScrl.isHidden = true
    }

    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnPresentation(_ sender: Any) {
        lblInscrire.isHidden = true
        lblPresentation.isHidden = false
        presentationScrl.isHidden = false
        lblPresent.isHidden = false
        insiseScrl.isHidden = true
        btnSin.setTitleColor(UIColor.init(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.5), for: .normal)
        btnPresentation.setTitleColor(UIColor.white, for: .normal)
    }
    
    @IBAction func btnSinscrire(_ sender: Any) {
        lblInscrire.isHidden = false
        lblPresentation.isHidden = true
        self.lblPresent.isHidden = true
        presentationScrl.isHidden = true
        insiseScrl.isHidden = false
        btnPresentation.setTitleColor(UIColor.init(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.5), for: .normal)
        btnSin.setTitleColor(UIColor.white, for: .normal)
        DispatchQueue.main.async {
            self.lblSinmsg.attributedText = self.regStr
        }
    }
    
    @IBAction func btnEnvoyer(_ sender: Any) {
        if txtCode.text == "" {
            Alert.show("Sainte Famillie", message: "Code utilisateur est obligatoire", onVC: self)
        }else if txtNom.text == "" {
            Alert.show("Sainte Famillie", message: "Nom de jeune fille est obligatoire", onVC: self)
        }else if txtPreNom.text == "" {
            Alert.show("Sainte Famillie", message: "Prénom est obligatoire", onVC: self)
        }else if txtPromotion.text == "" {
            Alert.show("Sainte Famillie", message: "Promotion est obligatoire", onVC: self)
        }else if txtClasse.text == "" {
            Alert.show("Sainte Famillie", message: "Classe fin d'étude au collège est obligatoire", onVC: self)
        }else if txtPrimaryEmail.text == "" {
            Alert.show("Sainte Famillie", message: "Email est obligatoire", onVC: self)
        }else if !txtPrimaryEmail.text!.isValidEmail{
            Alert.show("Sainte Famillie", message: "Please enter valid Email Address", onVC: self)
        }else {
            callRegistration()
        }
        
        
    }
    
    func spinnerChoose(_ spinner:LBZSpinner, index:Int,value:String) {
        lblEtatCivil.text = value
    }
    func callPresentation() {
        if !Reachability.isConnectedToNetwork() {
            Alert.show("Sainte Famillie", message: "Please check your internet connection", onVC: self)
        } else {
            Progress.show(toView: self.view)
            let url = URL(string: "http://api.sainte-famille.edu.lb/api/Presentation")
            URLSession.shared.dataTask(with: url!, completionHandler: {
                (data, response, error) in
                if(error != nil){
                    Progress.hide(toView: self.view)
                    print("error")
                }else{
                    do{
                        self.presArr = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! NSArray
                        
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
                            self.lblPresent.isHidden = false
                            

                            
                        self.webView.loadHTMLString(self.htmlStr, baseURL: nil)
                           
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
    func callRegistrationDetail() {
        if !Reachability.isConnectedToNetwork() {
            Alert.show("Sainte Famillie", message: "Please check your internet connection", onVC: self)
        } else {
            Progress.show(toView: self.view)
            let url = URL(string: "http://api.sainte-famille.edu.lb/api/RegistrationIntroduction")
            URLSession.shared.dataTask(with: url!, completionHandler: {
                (data, response, error) in
                if(error != nil){
                    print("error")
                }else{
                    do{
                        let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! NSArray
                        if json.count != 0 {
                            let dict = json.object(at: 0) as! NSDictionary
                            if dict.value(forKey: "PageContent") as? String != nil {
                                let htmlStr = dict.value(forKey: "PageContent") as! String
                                self.regStr = try! NSMutableAttributedString(data: htmlStr.data(using: String.Encoding.unicode, allowLossyConversion: true)!,options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],documentAttributes:nil)
                                self.regStr.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Bold", size: 17.0)!, range: NSRange(location: 0, length: self.regStr.length))
                                self.regStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.init(red: 63/255.0, green: 81/255.0, blue: 181/255.0, alpha: 1.0) , range: NSRange(location: 0, length: self.regStr.length))
                            }
                        }
                        print(json)
                        self.callPresentation()
                        
                    }catch let error as NSError{
                        print(error)
                        Alert.show("Sainte Famillie", message: "Something went wrong. Please try again", onVC: self)
                        Progress.hide(toView: self.view)
                    }
                }
            }).resume()
            
        }

    }
    
    @IBAction func btnDateClicked(_ sender: Any) {
        DatePickerDialog().show("Sainte Famillie", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                let formatter = DateFormatter()
                self.txtDate.textColor = UIColor.black
                formatter.dateFormat = "dd/MM/yyyy"
                self.txtDate.text = formatter.string(from: dt)
            }
        }
    }
    
    func callRegistration() {
        
        let headers: HTTPHeaders = ["Accept": "application/json", "Content-Type" :"application/json"]
        let familyStatusModel = ["UserCode":txtCode.text!,"Name":txtNom.text!,"FirstName":txtPreNom.text!,"DateOfBirth":txtDate.text!,"Promotion":txtPromotion.text!,"FineClassOfstudyInCollege":txtClasse.text!,"CivilStatus":lblEtatCivil.text!,"SpouseFName":txtNomConjoint.text!,
            "SpouseLName":txtPrenomConjoint.text!]
        let AddressModel = ["City":txtVille.text!,"District":txtQuartier.text!,"Building":txtImmeuble.text!,"CellPhone":txtCellulaire.text!,"Phone1":txtTel1.text!,"Phone2":txtTel2.text!,"PrimaryEmail":txtPrimaryEmail.text!,
            "SecondaryEmail":txtSecEmail.text!]
        let JobsModel = ["Profession":txtProfession.text!,"Society":txtSociete.text!,"City":txtVille1.text!,"Phone1":txtTel11.text!,"Phone2":txtTel22.text!]
        let OccupationSpouseModel = ["Profession":txtProfession1.text!,"Society":txtSociete1.text!,"City":txtVille2.text!,"Phone1":txtTel31.text!,"Phone2":txtTel32.text!]
        let dict = ["FamilyStatusModel":familyStatusModel,"AddressModel":AddressModel,"JobsModel":JobsModel,"OccupationSpouseModel":OccupationSpouseModel,"Message":txtMsg.text!] as [String : Any]
        Progress.show(toView: self.view)
        Alamofire.request("http://api.sainte-famille.edu.lb/api/Register/Sinscrire", method: .post, parameters: dict, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            // original URL request
            print("Request is :",response.request!)
            
            // HTTP URL response --> header and status code
            print("Response received is :",response.response!)
            
            // server data : example 267 bytes
            print("Response data is :",response.data!)
            Progress.hide(toView: self.view)
            do {
                let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! NSDictionary
                if json.value(forKey: "success") as! String == "1" {
                    let alertView = UIAlertController(title: "Sainte Famillie", message: "Email sent successfully. Info@sainte-famille.edu.lb", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                        self.navigationController?.popViewController(animated: true)
                    })
                    alertView.addAction(action)
                    self.present(alertView, animated: true, completion: nil)
                } else {
                    Alert.show("Sainte Famillie", message: "Something went wrong. Please try again", onVC: self)
                }
            } catch _ {
                Alert.show("Sainte Famillie", message: "Something went wrong. Please try again", onVC: self)
            }
            
            // result of response serialization : SUCCESS / FAILURE
            print("Response result is :",response.result)
            
            debugPrint("Debug Print :", response)
        }
    }
    
}

extension AnciensController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension AnciensController:UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
extension AnciensController:UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        Progress.hide(toView: self.view)
        self.lblPresent.text = self.sectionName
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        Progress.hide(toView: self.view)
    }
}
