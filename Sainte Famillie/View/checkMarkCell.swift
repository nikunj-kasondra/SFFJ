//
//  checkMarkCell.swift
//  Sainte Famillie
//
//  Created by Rujal on 4/27/18.
//  Copyright © 2018 Nikunj. All rights reserved.
//

import UIKit

class checkMarkCell: UITableViewCell {

    @IBOutlet weak var lblCheckMarkId: UILabel!
    @IBOutlet weak var imgCheckMark: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
