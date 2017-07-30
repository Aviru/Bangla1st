//
//  AddressTableViewCell.swift
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 30/07/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

import UIKit

class AddressTableViewCell: UITableViewCell {
    
    @IBOutlet var imgVwTextFieldBorder: UIImageView!
    
    @IBOutlet var imgVwIcon: UIImageView!
    
    @IBOutlet var imgVwRedStar: UIImageView!
    
    @IBOutlet var txtFieldAddress: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
