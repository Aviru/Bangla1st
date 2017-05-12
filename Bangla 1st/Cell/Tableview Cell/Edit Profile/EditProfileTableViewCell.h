//
//  EditProfileTableViewCell.h
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 29/04/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditProfileTableViewCell : UITableViewCell

////PROFILE CELL

@property (strong, nonatomic) IBOutlet UITextField *txtEditprofileInfo;

@property (strong, nonatomic) IBOutlet UIImageView *imgVwDropDownIcon;


////GENDER CELL

@property (weak, nonatomic) IBOutlet UIButton *btnMaleOutlet;
@property (weak, nonatomic) IBOutlet UIImageView *imgVwMaleRadioIcon;

@property (weak, nonatomic) IBOutlet UIButton *btnFemaleOutlet;
@property (weak, nonatomic) IBOutlet UIImageView *imgVwFemaleRadioIcon;


////PASSWORD CELL

@property (strong, nonatomic) IBOutlet UITextField *txtEditPassword;

@property (weak, nonatomic) IBOutlet UIImageView *imgVwTextFieldBorder;

@property (weak, nonatomic) IBOutlet UIImageView *imgVwEyeIcon;

@property (weak, nonatomic) IBOutlet UIButton *btnShowPasswordOutlet;

@end
