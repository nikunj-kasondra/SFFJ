//
//  AddAnnoController.swift
//  Sainte Famillie
//
//  Created by Rujal on 1/21/18.
//  Copyright © 2018 Nikunj. All rights reserved.
//

import UIKit

class AddAnnoController: UIViewController {
     @IBOutlet weak var tblAgenda: UITableView!
    @IBOutlet weak var lblId: UILabel!
    @IBOutlet weak var txtDetail: UITextView!
    @IBOutlet weak var txtSubject: UITextField!
    static var id = String()
    static var materialId = String()
    static var code = String()
    var checkMarkArr = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        lblId.text = AddAnnoController.id
        tblAgenda.register(UINib(nibName: "checkMarkCell", bundle: nil), forCellReuseIdentifier: "newCell")
        tblAgenda.separatorStyle = .none
        tblAgenda.estimatedRowHeight = 44
        tblAgenda.rowHeight = UITableViewAutomaticDimension
        checkMarkArr.removeAllObjects()
        checkMarkArr.add(MatricesController.serCode )
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func btnEnvoyerClicked(_ sender: Any) {
        if txtSubject.text! == "" {
            Alert.show("SFFJ", message: "Please enter subject", onVC: self)
            return
        } else if txtDetail.text! == "" {
            Alert.show("SFFJ", message: "Please enter detail", onVC: self)
            return
        } else if checkMarkArr.count == 0 {
            Alert.show("SFFJ", message: "Please select atleast one agenda", onVC: self)
            return
        }
        callEnvoyer()
    }
    
    func callEnvoyer() {
        let tmpStr = checkMarkArr.componentsJoined(by:"," )
        if !Reachability.isConnectedToNetwork() {
            Alert.show("Sainte Famillie", message: "Please check your internet connection", onVC: self)
        } else {
            Progress.show(toView: self.view)
            let url = "http://api.sainte-famille.edu.lb/api/login/getteacherinsertedannouncements?materialId=\(tmpStr)&subject=\(txtSubject.text!)&details=\(txtDetail.text!)"
            let urlStr : String = url.addingPercentEscapes(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
            let url1 = URL(string:urlStr)
            
            URLSession.shared.dataTask(with: url1!, completionHandler: {
                (data, response, error) in
                if(error != nil){
                    Progress.hide(toView: self.view)
                    print("error")
                }else{
                    Progress.hide(toView: self.view)
                    do{
                        let presArr = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! NSArray
                        let VC = Common.storyboard.instantiateViewController(withIdentifier: "AnnounceListController")
                        Navigation.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
                        print(presArr)
                        
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
}

extension AddAnnoController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MatricesController.resArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newCell") as! checkMarkCell
        cell.lblCheckMarkId.text = (MatricesController.resArr.value(forKey: "Code") as! NSArray).object(at: indexPath.row) as? String
        let tmp = (MatricesController.resArr.value(forKey: "Code") as! NSArray).object(at: indexPath.row) as! String
        if checkMarkArr.contains(tmp) {
            cell.imgCheckMark.image = #imageLiteral(resourceName: "checkmark")
        } else {
            cell.imgCheckMark.image = #imageLiteral(resourceName: "uncheckmark")
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tblAgenda.cellForRow(at: IndexPath(item: indexPath.row, section: 0)) as! checkMarkCell
        if cell.imgCheckMark.image == #imageLiteral(resourceName: "checkmark") {
            cell.imgCheckMark.image = #imageLiteral(resourceName: "uncheckmark")
            for i in 0..<checkMarkArr.count {
                if checkMarkArr.object(at: i) as! String == cell.lblCheckMarkId.text! {
                    checkMarkArr.removeObject(at: i)
                    break
                }
            }
        } else {
            cell.imgCheckMark.image = #imageLiteral(resourceName: "checkmark")
            checkMarkArr.add((MatricesController.resArr.value(forKey: "Code") as! NSArray).object(at: indexPath.row) as! String)
        }
    }
}

extension AddAnnoController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtDetail.becomeFirstResponder()
        return true
    }
    
}

extension AddAnnoController:UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
