//
//  CenterDetailVC.swift
//  Sainte Famillie
//
//  Created by Rujal on 3/26/18.
//  Copyright © 2018 Nikunj. All rights reserved.
//

import UIKit

class CenterDetailVC: UIViewController {

    @IBOutlet weak var lbl5: UILabel!
    @IBOutlet weak var lbl4: UILabel!
    @IBOutlet weak var lbl3: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var lbl1: UILabel!
    static var dict = NSDictionary()
    override func viewDidLoad() {
        super.viewDidLoad()
        let htmlStr = (CenterDetailVC.dict.value(forKey: "titre") as! String)
        let attrStr = try! NSAttributedString(
            data: (htmlStr.data(using: String.Encoding.unicode, allowLossyConversion: true)!),
            options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
            documentAttributes: nil)
        lbl2.text = "Titre: " + htmlStr
        lbl1.text = "Code Document: " + String(describing:(CenterDetailVC.dict.value(forKey: "CodeDocument")  as! NSNumber))
        lbl3.text = "Auteurs: " + String(describing:(CenterDetailVC.dict.value(forKey: "Auteurs")  as! String))
        lbl4.text = "Editeur : " + String(describing:(CenterDetailVC.dict.value(forKey: "editeur")  as! String))
        lbl5.text = "AnneeEdition : " + String(describing:(CenterDetailVC.dict.value(forKey: "AnneeEdition")  as! String))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
