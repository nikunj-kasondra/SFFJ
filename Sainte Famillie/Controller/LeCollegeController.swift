//
//  LeCollegeController.swift
//  Sainte Famillie
//
//  Created by Rujal on 11/15/17.
//  Copyright © 2017 Nikunj. All rights reserved.
//

import UIKit

class LeCollegeController: UIViewController {

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
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnOrganimee(_ sender: Any) {
        let VC = Common.storyboard.instantiateViewController(withIdentifier: "OrganigrammeController")
        Navigation.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
    }
    @IBAction func btnEstablisment(_ sender: Any) {
        let VC = Common.storyboard.instantiateViewController(withIdentifier: "ProjetdEtablissementController")
        Navigation.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
    }
    @IBAction func btnEducatif(_ sender: Any) {
        let VC = Common.storyboard.instantiateViewController(withIdentifier: "ProjetEducatifController")
        Navigation.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
    }
    @IBAction func btnHistorie(_ sender: Any) {
        let VC = Common.storyboard.instantiateViewController(withIdentifier: "HistoireDetailController")
        Navigation.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
    }
    @IBAction func btnPresentation(_ sender: Any) {
        let VC = Common.storyboard.instantiateViewController(withIdentifier: "PresentationDetailController")
        Navigation.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
    }

    @IBAction func btnDemand(_ sender: Any) {
        UIApplication.shared.openURL(URL(string: "http://sainte-famille.edu.lb/Emploi/Login/100")!)
    }
    @IBAction func btnAdmision(_ sender: Any) {
        
        let VC = Common.storyboard.instantiateViewController(withIdentifier: "AdmissionsVC")
        Navigation.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
    }
}

