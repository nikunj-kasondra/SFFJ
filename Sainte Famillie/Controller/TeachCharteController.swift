//
//  TeachCharteController.swift
//  Sainte Famillie
//
//  Created by Rujal on 1/19/18.
//  Copyright © 2018 Nikunj. All rights reserved.
//

import UIKit

class TeachCharteController: UIViewController {
    var presArr = NSArray()
    @IBOutlet weak var tblTeach: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        tblTeach.register(UINib(nibName: "CharteCell", bundle: nil), forCellReuseIdentifier: "newCell")
        tblTeach.separatorStyle = .none
        tblTeach.estimatedRowHeight = 44
        tblTeach.rowHeight = UITableViewAutomaticDimension
        callPresentation()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    func callPresentation() {
        if !Reachability.isConnectedToNetwork() {
            Alert.show("Sainte Famillie", message: "Please check your internet connection", onVC: self)
        } else {
            
            Progress.show(toView: self.view)
            var urlStr = ""

                
            urlStr = "http://api.sainte-famille.edu.lb/api/login/getteacherchartedevie?userName=\(UserDefaults.standard.object(forKey: "Code") as! String)"
            
            let url = URL(string: urlStr)
            URLSession.shared.dataTask(with: url!, completionHandler: {
                (data, response, error) in
                if(error != nil){
                    Progress.hide(toView: self.view)
                    print("error")
                }else{
                    do{
                        Progress.hide(toView: self.view)
                        self.presArr = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! NSArray
                        DispatchQueue.main.async {
                            self.tblTeach.reloadData()
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

extension TeachCharteController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newCell") as! CharteCell
        cell.lblTitle.text = (self.presArr.value(forKey: "title") as! NSArray).object(at: indexPath.row) as? String
        if let slogan = (self.presArr.value(forKey: "slogan") as! NSArray).object(at: indexPath.row) as? String {
            let attrStr = try! NSAttributedString(
                data: (slogan.data(using: String.Encoding.unicode, allowLossyConversion: true)!),
                options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                documentAttributes: nil)
            cell.lblLink.attributedText = attrStr
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
