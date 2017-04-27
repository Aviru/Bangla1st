//
//  SignUpTableViewCell.h
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 21/04/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SignUpTableViewCell : UITableViewCell

///NORMAL CELL
@property (strong, nonatomic) IBOutlet UITextField *txtSignUpFields;

@property (strong, nonatomic) IBOutlet UIImageView *imgVwIconTextFields;

@property (weak, nonatomic) IBOutlet UIImageView *imgVwTextFieldBorder;

@property (weak, nonatomic) IBOutlet UIImageView *imgVwEyeIcon;

@property (weak, nonatomic) IBOutlet UIButton *btnShowPasswordOutlet;



///DROP DOWN CELL
@property (weak, nonatomic) IBOutlet UIImageView *imgVwIconDropDown;

@property (weak, nonatomic) IBOutlet UIButton *btnDropDownOutlet;

@property (weak, nonatomic) IBOutlet UILabel *lblDropDown;

@property (weak, nonatomic) IBOutlet UIImageView *imgVwDropDownArrow;

@property (weak, nonatomic) IBOutlet UITextField *txtDropDown;


///GENDER CELL
@property (weak, nonatomic) IBOutlet UIButton *btnMaleOutlet;
@property (weak, nonatomic) IBOutlet UIImageView *imgVwMaleRadioIcon;

@property (weak, nonatomic) IBOutlet UIButton *btnFemaleOutlet;
@property (weak, nonatomic) IBOutlet UIImageView *imgVwFemaleRadioIcon;


@end
