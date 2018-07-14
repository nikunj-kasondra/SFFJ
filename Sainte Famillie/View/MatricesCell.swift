//
//  MatricesCell.swift
//  Sainte Famillie
//
//  Created by Rujal on 1/19/18.
//  Copyright © 2018 Nikunj. All rights reserved.
//

import UIKit

class MatricesCell: UITableViewCell {

    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnAnnouncement: UIButton!
    @IBOutlet weak var btnAgenda: UIButton!
    @IBOutlet weak var lblName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
