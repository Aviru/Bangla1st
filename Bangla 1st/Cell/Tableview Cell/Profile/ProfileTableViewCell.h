//
//  ProfileTableViewCell.h
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 09/04/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoundedButton.h"

@interface ProfileTableViewCell : UITableViewCell

///PROFILE PIC CELL

@property (strong, nonatomic) IBOutlet UIImageView *imgVwProfilePic;
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet RoundedButton *btnEditProfileOutlet;


///PROFILE DETAILS CELL

@property (strong, nonatomic) IBOutlet UILabel *lblProfileName;
@property (strong, nonatomic) IBOutlet UILabel *lblProfileEmail;
@property (strong, nonatomic) IBOutlet UILabel *lblProfileGender;
@property (strong, nonatomic) IBOutlet UILabel *lblProfileDob;
@property (strong, nonatomic) IBOutlet UILabel *lblProfileCountry;


///RECOMENDED PLAN CELL

@property (strong, nonatomic) IBOutlet UILabel *lblHeader;
@property (strong, nonatomic) IBOutlet UILabel *lblContent;
@property (weak, nonatomic) IBOutlet UITextView *txtVwContent;


///CURRENT PLAN CELL

@property (strong, nonatomic) IBOutlet UILabel *lblRecomendedContent;
@property (strong, nonatomic) IBOutlet RoundedButton *btnUpgradeOutlet;
@property (weak, nonatomic) IBOutlet UITextView *txtVwRecomendedContent;

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UILabel *lblPackageName;

@property (weak, nonatomic) IBOutlet UILabel *lblPackagePrice;

@property (weak, nonatomic) IBOutlet UILabel *lblValidity;

@property (weak, nonatomic) IBOutlet UILabel *lblVideoWatchLimit;

@property (weak, nonatomic) IBOutlet UILabel *lblTotalLimit;

@property (weak, nonatomic) IBOutlet UILabel *lblPackageStatus;

@property (weak, nonatomic) IBOutlet UILabel *lblNoSubscription;


@end
