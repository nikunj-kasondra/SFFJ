//
//  ProductionController.swift
//  Sainte Famillie
//
//  Created by Rujal on 11/27/17.
//  Copyright © 2017 Nikunj. All rights reserved.
//

import UIKit

class ProductionController: UIViewController {

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
    
    @IBAction func btnPublication(_ sender: Any) {
        let VC = Common.storyboard.instantiateViewController(withIdentifier: "PublicationController")
        Navigation.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnPain(_ sender: Any) {
        let VC = Common.storyboard.instantiateViewController(withIdentifier: "TalentController")
        Navigation.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
    }
    @IBAction func btnDesProf(_ sender: Any) {
        let VC = Common.storyboard.instantiateViewController(withIdentifier: "ProdProfController")
        Navigation.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
    }
    
    @IBAction func btnDes(_ sender: Any) {
        let VC = Common.storyboard.instantiateViewController(withIdentifier: "ProductionsDesController")
        Navigation.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
    }
    
    @IBAction func btnLivre(_ sender: Any) {
        let VC = Common.storyboard.instantiateViewController(withIdentifier: "LivreController")
        Navigation.push_POP_to_ViewController(destinationVC: VC, navigationsController: Common.navigationController, isAnimated: true)
    }
    
    
    

}
