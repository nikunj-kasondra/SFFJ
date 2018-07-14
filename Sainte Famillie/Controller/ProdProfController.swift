//
//  ProdProfController.swift
//  Sainte Famillie
//
//  Created by Rujal on 11/29/17.
//  Copyright © 2017 Nikunj. All rights reserved.
//

import UIKit

class ProdProfController: UIViewController {

    @IBOutlet weak var tblProf: UITableView!
    var prodArr = NSArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        tblProf.register(UINib(nibName: "LivreCell", bundle: nil), forCellReuseIdentifier: "newCell")
        tblProf.separatorStyle = .none
        tblProf.estimatedRowHeight = 44
        tblProf.rowHeight = UITableViewAutomaticDimension
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
            let url = URL(string: "http://api.sainte-famille.edu.lb/api/pagedacceuil/getproductionsdesprofs")
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
                        self.tblProf.reloadData()
                    }
                }
            }).resume()
            
        }
    }

}

extension ProdProfController: UITableViewDelegate,UITableViewDataSource {
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
        ProdProfDetailController.profId = ((self.prodArr.value(forKey: "Id") as! NSArray).object(at: indexPath.row) as? NSNumber)!
        let VC = Common.storyboard.instantiateViewController(withIdentifier: "ProdProfDetailController")
        Navigation.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
    }
}

