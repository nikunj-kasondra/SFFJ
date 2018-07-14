//
//  LoginDashController.swift
//  Sainte Famillie
//
//  Created by Rujal on 12/15/17.
//  Copyright © 2017 Nikunj. All rights reserved.
//

import UIKit

class LoginDashController: UIViewController {
    var nameArr = [String]()
    var colorCodeArr = [String]()
    
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var homeCollection: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        homeCollection.register(UINib(nibName: "LoginDashCell", bundle: nil), forCellWithReuseIdentifier: "newCell")
        let flag = UserDefaults.standard.object(forKey: "AlreadyLogin") as! String
        if let headerName = UserDefaults.standard.object(forKey:"headerName") as? String {
            lblHeader.text = headerName
        }
        
        if flag == "P" || flag == "S"{
        nameArr = ["Agenda Scolaire","Documents","Annonces","Circulaires","","Carnets","Centre de Documentation","Charte de Vie","Listes de Livres","Fiches de I'assistante sociale","Sondage","Règlement de I'école","","Informations personnelles",""]
        } else {
            nameArr = ["Matières","","Circulaires","Centre de Documentation","Charte de Vie","Listes de Livres","Fiches de I'assistante sociale","Sondage","","","","Règlement de I'école","","Informations personnelles",""]
            
        }
        colorCodeArr = ["#8ac349","#fa8b00","#2d42af","#1e87e4","#fcd839","#9475cd","#FA8B00","#ef6192","#279a42","#2DC5DA","#b968c7","#7AA9F7","#F32B44","#FBD30A","#04519A"]

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnBackClicked(_ sender: Any) {
        let VC = Common.storyboard.instantiateViewController(withIdentifier: "DashboardController")
        Navigation.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
    }
}

extension LoginDashController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nameArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newCell", for: indexPath) as! LoginDashCell
        cell.lblName.text = nameArr[indexPath.row]
        cell.contentView.backgroundColor = UIColor.init(hexString: colorCodeArr[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((UIScreen.main.bounds.size.width) / 3), height:((UIScreen.main.bounds.size.height)-64) / 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let flag = UserDefaults.standard.object(forKey: "AlreadyLogin") as! String
        if indexPath.row == 0{
            if flag == "S" || flag == "P" {
                let VC = Common.storyboard.instantiateViewController(withIdentifier: "AgendaController")
                Navigation.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
            } else {
                let VC = Common.storyboard.instantiateViewController(withIdentifier: "MatricesController")
                Navigation.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
            }
            
        } else if indexPath.row == 1 {
            if flag == "S" || flag == "P" {
            let VC = Common.storyboard.instantiateViewController(withIdentifier: "DocumentController")
            Navigation.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
            } else {
                
            }
        } else if indexPath.row == 2 {
            if flag == "S" || flag == "P" {
            let VC = Common.storyboard.instantiateViewController(withIdentifier: "AnnocesController")
            Navigation.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
            } else {
                let VC = Common.storyboard.instantiateViewController(withIdentifier: "ListCircularController")
                Navigation.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
            }
        } else if indexPath.row == 3 {
            if flag == "S" || flag == "P" {
            let VC = Common.storyboard.instantiateViewController(withIdentifier: "ListCircularController")
            Navigation.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
            } else {
                let VC = Common.storyboard.instantiateViewController(withIdentifier: "ListeDocController")
            Navigation.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
                
            }
        } else if indexPath.row == 4 {
            if flag == "S" || flag == "P" {
//                let VC = Common.storyboard.instantiateViewController(withIdentifier: "CarnetsController")
//                Navigation.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
            } else {
                let VC = Common.storyboard.instantiateViewController(withIdentifier: "TeachCharteController")
                Navigation.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
            }
        } else if indexPath.row == 5 {
            if flag == "S" || flag == "P" {
            let VC = Common.storyboard.instantiateViewController(withIdentifier: "CarnetsController")
            Navigation.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
            } else {
                let VC = Common.storyboard.instantiateViewController(withIdentifier: "LivrePdfController")
                Navigation.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
            }
        } else if indexPath.row == 6 {
            if flag == "S" || flag == "P" {
                let VC = Common.storyboard.instantiateViewController(withIdentifier: "ListeDocController")
            Navigation.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
            } else {
                let VC = Common.storyboard.instantiateViewController(withIdentifier: "FichesController")
                Navigation.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
            }
        } else if indexPath.row == 7 {
            if flag == "S" || flag == "P" {
            let VC = Common.storyboard.instantiateViewController(withIdentifier: "ChartdeController")
            Navigation.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
            } else {
                let VC = Common.storyboard.instantiateViewController(withIdentifier: "SondageController")
                Navigation.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
            }
        } else if indexPath.row == 8 {
            if flag == "S" || flag == "P" {
                let VC = Common.storyboard.instantiateViewController(withIdentifier: "LivrePdfController")
                Navigation.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
            } else {
                
            }
        } else if indexPath.row == 9 {
            if flag == "S" || flag == "P" {
            let VC = Common.storyboard.instantiateViewController(withIdentifier: "FichesController")
            Navigation.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
            } else {
                
            }
        } else if indexPath.row == 10 {
                let VC = Common.storyboard.instantiateViewController(withIdentifier: "SondageController")
                Navigation.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
        } else if indexPath.row == 13 {
            if let login = UserDefaults.standard.object(forKey: "AlreadyLogin"){
                print(login)
                let flag = UserDefaults.standard.object(forKey: "AlreadyLogin") as! String
                if flag == "S" {
                    let VC = Common.storyboard.instantiateViewController(withIdentifier: "PersonnelInfoController")
                    Navigation.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
                    
                } else if flag == "P" {
                    let VC = Common.storyboard.instantiateViewController(withIdentifier: "ParentInfoController")
                    Navigation.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
                } else if flag == "T" {
                    let VC = Common.storyboard.instantiateViewController(withIdentifier: "TeacherPersonalInfoController")
                    Navigation.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
                    
                }
            }
            
        } else if indexPath.row == 11 {
            if flag == "S" || flag == "P" {
            let VC = Common.storyboard.instantiateViewController(withIdentifier: "ReglementController")
            Navigation.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
            } else {
                let VC = Common.storyboard.instantiateViewController(withIdentifier: "ReglementController")
                Navigation.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
            }
        }
    }
}

