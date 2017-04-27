//
//  JustForYouTableViewCell.m
//  Bangla 1st
//
//  Created by Aviru bhattacharjee on 16/04/17.
//  Copyright © 2017 Abhijit Rana. All rights reserved.
//

#import "JustForYouTableViewCell.h"

@implementation JustForYouTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [_containerVw.layer setCornerRadius:2.0f];
    
    // border
    [_containerVw.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [_containerVw.layer setBorderWidth:0.5f];
    
    // drop shadow
    [_containerVw.layer setShadowColor:[UIColor blackColor].CGColor];
    [_containerVw.layer setShadowOpacity:0.4];
    [_containerVw.layer setShadowRadius:1.0];
    [_containerVw.layer setShadowOffset:CGSizeMake(1.0, 1.0)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
