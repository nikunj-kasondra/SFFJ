//
//  ListeDocController.swift
//  Sainte Famillie
//
//  Created by Rujal on 3/25/18.
//  Copyright © 2018 Nikunj. All rights reserved.
//

import UIKit

class ListeDocController: UIViewController {
    
    @IBOutlet weak var tblSearch: UITableView!
    @IBOutlet weak var spinner5: LBZSpinner!
    @IBOutlet weak var spinner4: LBZSpinner!
    @IBOutlet weak var spinner3: LBZSpinner!
    @IBOutlet weak var spinner2: LBZSpinner!
    @IBOutlet weak var spinner1: LBZSpinner!
    @IBOutlet weak var txtTitle: UITextField!
    var dropArr = NSArray()
    var searchArr = NSArray()
    var str1:Int = 0
    var str2:String = ""
    var str3:String = ""
    var str4:String = ""
    var str5:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        tblSearch.register(UINib(nibName: "DocCell", bundle: nil), forCellReuseIdentifier: "newCell")
        tblSearch.separatorStyle = .none
        tblSearch.estimatedRowHeight = 44
        tblSearch.rowHeight = UITableViewAutomaticDimension
        callDropDown()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func callDropDown(){
        
        if !Reachability.isConnectedToNetwork() {
            Alert.show("Sainte Famillie", message: "Please check your internet connection", onVC: self)
        } else {
            Progress.show(toView: self.view)
            let url = URL(string: "http://api.sainte-famille.edu.lb/api/login/getcentrededocumentationddl")
            URLSession.shared.dataTask(with: url!, completionHandler: {
                (data, response, error) in
                if(error != nil){
                    Progress.hide(toView: self.view)
                    print("error")
                }else{
                    do{
                        self.dropArr = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! NSArray
                        let center = (((self.dropArr.value(forKey: "CenterEEBCDModelList") as! NSArray).value(forKey: "CENTRE") as! NSArray).object(at: 0) as! NSArray).mutableCopy() as! NSMutableArray
                        center.insert("Centre", at: 0)
                        
                        self.spinner5.updateList(center as! [String])
                        self.spinner5.delegate = self
                        let genre = (((self.dropArr.value(forKey: "GenreEBCDModelList") as! NSArray).value(forKey: "Genre") as! NSArray).object(at: 0) as! NSArray).mutableCopy() as! NSMutableArray
                        genre.insert("Genre", at: 0)
                        
                        self.spinner4.updateList(genre as! [String])
                        self.spinner4.delegate = self
                        
                        let typeDoc = (((self.dropArr.value(forKey: "NatureEBCDModelList") as! NSArray).value(forKey: "Nature") as! NSArray).object(at: 0) as! NSArray).mutableCopy() as! NSMutableArray
                        typeDoc.insert("Type Doc", at: 0)
                        
                        self.spinner3.updateList(typeDoc as! [String])
                        self.spinner3.delegate = self
                        
                        let support = (((self.dropArr.value(forKey: "SupportEBCDModelList") as! NSArray).value(forKey: "Support") as! NSArray).object(at: 0) as! NSArray).mutableCopy() as! NSMutableArray
                        support.insert("Support", at: 0)
                        
                        self.spinner2.updateList(support as! [String])
                        self.spinner2.delegate = self
                        let niveau = ["Niveau","Terminale", "Premiere", "Seconde", "Troisieme", "Quatrieme", "Cinquieme", "sixieme",  "septieme" ]
                        self.spinner1.updateList(niveau)
                        self.spinner1.delegate = self
                        print(self.dropArr)
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
    @IBAction func btnSearch(_ sender: Any) {
        if !Reachability.isConnectedToNetwork() {
            Alert.show("Sainte Famillie", message: "Please check your internet connection", onVC: self)
        } else {
            Progress.show(toView: self.view)
            let url = URL(string: "http://api.sainte-famille.edu.lb/api/login/getcentrededocumentationlist?titre=\(txtTitle.text!)&niveau=\(str1)&support=\(str2)&nature=\(str3)&genre=\(str4)&emplacement=\(str5)")
            URLSession.shared.dataTask(with: url!, completionHandler: {
                (data, response, error) in
                if(error != nil){
                    Progress.hide(toView: self.view)
                    print("error")
                }else{
                    do{
                        self.searchArr = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! NSArray
                        Progress.hide(toView: self.view)
                        DispatchQueue.main.async {
                            self.tblSearch.reloadData()
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
extension ListeDocController : LBZSpinnerDelegate {
    func spinnerChoose(_ spinner: LBZSpinner, index: Int, value: String) {
        if spinner1 == spinner {
            str1 = index
        } else if spinner2 == spinner {
            if index == 0 {
                str2 = ""
            } else {
                str2 = value
            }
        } else if spinner3 == spinner {
            if index == 0 {
                str3 = ""
            } else {
                str3 = value
            }
        } else if spinner4 == spinner {
            if index == 0 {
                str4 = ""
            } else {
                str4 = value
            }
        } else if spinner5 == spinner {
            if index == 0 {
                str5 = ""
            } else {
                str5 = value
            }
        }
    }
}

extension ListeDocController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
extension ListeDocController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newCell", for: indexPath) as! DocCell
        let htmlStr = (searchArr.value(forKey: "titre") as! NSArray).object(at: indexPath.row) as? String
        let attrStr = try! NSAttributedString(
            data: (htmlStr?.data(using: String.Encoding.unicode, allowLossyConversion: true)!)!,
            options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
            documentAttributes: nil)
        
        cell.lbl2.text = "Titre: " + htmlStr!
        cell.lbl1.text = "Code Document: " + String(describing:(searchArr.value(forKey: "CodeDocument") as! NSArray).object(at: indexPath.row) as! NSNumber)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        CenterDetailVC.dict = searchArr.object(at: indexPath.row) as! NSDictionary
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "CenterDetailVC")
        self.navigationController?.pushViewController(VC!, animated: true)
    }
}
