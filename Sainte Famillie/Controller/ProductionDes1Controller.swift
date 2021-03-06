//
//  ProductionDes1Controller.swift
//  Sainte Famillie
//
//  Created by Rujal on 11/29/17.
//  Copyright © 2017 Nikunj. All rights reserved.
//

import UIKit

class ProductionDes1Controller: UIViewController {

    @IBOutlet weak var tblProd1: UITableView!
    static var prodId = NSNumber()
    var prodArr = NSArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        tblProd1.register(UINib(nibName: "LivreCell", bundle: nil), forCellReuseIdentifier: "newCell")
        tblProd1.separatorStyle = .none
        tblProd1.estimatedRowHeight = 44
        tblProd1.rowHeight = UITableViewAutomaticDimension
        callProdAPI()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func callProdAPI() {
        if !Reachability.isConnectedToNetwork() {
            Alert.show("Sainte Famillie", message: "Please check your internet connection", onVC: self)
        } else {
            Progress.show(toView: self.view)
            let url = URL(string: "http://api.sainte-famille.edu.lb/api/pagedacceuil/getproductionsdeselevesclassescategories?classId=\(ProductionDes1Controller.prodId)")
            URLSession.shared.dataTask(with: url!, completionHandler: {
                (data, response, error) in
                
                if(error != nil){
                    Progress.hide(toView: self.view)
                    print("error")
                }else{
                    do{
                        Progress.hide(toView: self.view)
                        self.prodArr = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! NSArray
                        
                    }
                    catch let error as NSError{
                        print(error)
                        Alert.show("Sainte Famillie", message: "Something went wrong. Please try again", onVC: self)
                        Progress.hide(toView: self.view)
                    }
                    DispatchQueue.main.async {
                        self.tblProd1.reloadData()
                    }
                }
            }).resume()
            
        }
    }
    
}


extension ProductionDes1Controller: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.prodArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newCell") as! LivreCell
        cell.lblLibre.text = (self.prodArr.value(forKey: "Name") as! NSArray).object(at: indexPath.row) as? String
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ProdDetailController.prod1Id = ((self.prodArr.value(forKey: "Id") as! NSArray).object(at: indexPath.row) as? NSNumber)!
        let VC = Common.storyboard.instantiateViewController(withIdentifier: "ProdDetailController")
        Navigation.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
    }
}
