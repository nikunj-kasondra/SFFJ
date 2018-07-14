//
//  AnnoncesImagesVC.swift
//  Sainte Famillie
//
//  Created by Rujal on 2/27/18.
//  Copyright © 2018 Nikunj. All rights reserved.
//

import UIKit

class AnnoncesImagesVC: UIViewController {

    @IBOutlet weak var img: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        img?.kf.setImage(with: URL(string:AnnoncesDetailVC.imgStr), placeholder:UIImage(named:""), options: nil, progressBlock: nil, completionHandler:nil)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnDownloadClicked(_ sender: Any) {
        UIImageWriteToSavedPhotosAlbum(img.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "SFFJ", message: "Annonces image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
}
