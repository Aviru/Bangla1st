//
//  SectionHeaderView.swift
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 30/07/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

import UIKit

class SectionHeaderView: UIView {
    
    @IBOutlet var lblSectionHeader: UILabel!
    
    @IBOutlet var imgVwCheckBoxIcon: UIImageView!
    
    @IBOutlet var btnCheckBoxOutlet: UIButton!
    
    @IBOutlet var lblSameBillingInfo: UILabel!
    
     var buttonCheckboxFunc: (() -> (Void))!
    
    @IBAction func btnCheckBoxAction(_ sender: Any) {
        
        buttonCheckboxFunc()
    }
    
    func setButtonCheckboxTapFunction(_ function: @escaping () -> Void) {
        self.buttonCheckboxFunc = function
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
