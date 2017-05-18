//
//  ProfileTableViewCell.m
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 09/04/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "ProfileTableViewCell.h"

@implementation ProfileTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.imgVwProfilePic.layer.cornerRadius = [[UIScreen mainScreen]bounds].size.width/2 * .3;
    
    self.imgVwProfilePic.clipsToBounds = YES;
    self.imgVwProfilePic.layer.borderWidth = 1.0;
    self.imgVwProfilePic.layer.borderColor = [UIColor colorWithRed:255.0/255.0 green:83.0/255.0 blue:31.0/255.0 alpha:1.0].CGColor;
    
    [_containerView.layer setCornerRadius:3.0f];
    
    // border
    [_containerView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [_containerView.layer setBorderWidth:0.5f];
    
    // drop shadow
    [_containerView.layer setShadowColor:[UIColor blackColor].CGColor];
    [_containerView.layer setShadowOpacity:0.4];
    [_containerView.layer setShadowRadius:1.0];
    [_containerView.layer setShadowOffset:CGSizeMake(1.0, 1.0)];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
