//
//  AgendaCell.swift
//  Sainte Famillie
//
//  Created by Rujal on 1/31/18.
//  Copyright © 2018 Nikunj. All rights reserved.
//

import UIKit

class AgendaCell: UITableViewCell {

    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnEye: UIButton!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lblSubject: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
